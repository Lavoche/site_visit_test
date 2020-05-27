defmodule SiteVisit.LinksRouter do
    use Plug.Router
    use Plug.ErrorHandler

    plug(:match)
    plug(Plug.Logger, log: :debug)    
    plug (:dispatch)

    post "/" do
        
        {:ok, body, conn} = read_body(conn)
        body = Poison.decode!(body)
        links = get_in(body, ["links"])
        timestamp = if (!get_in(body, ["test"])), do:  DateTime.to_unix(DateTime.utc_now()) |> Integer.to_string, 
                                                  else: "0"
        if links do    
            Enum.map(links, fn(s) -> 
                site = Regex.run(~r/[a-zA-Zа-яА-ЯёЁ0-9_-]+(\.[a-zA-Zа-яА-ЯёЁ0-9_-]+)*\.[a-zA-Zа-яА-ЯёЁ]{2,5}(?=$|[^a-zA-Zа-яА-ЯёЁ0-9_-])/, s) |> Enum.min |> String.downcase
                SiteVisit.DB.set(site, timestamp)
            end)
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(message("ok")))
        else
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, Poison.encode!(message("not found links")))
        end    
    end
   
    match _ do 
        send_resp(conn, 404, " ")
    end

    defp message(status) do
        %{
            status: status
        }
    end

    defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack} = err) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(conn.status, Poison.encode!(message(err.kind)))
        
    end

end