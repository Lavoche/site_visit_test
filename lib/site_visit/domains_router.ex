defmodule SiteVisit.DomainsRouter do
    use Plug.Router
    use Plug.ErrorHandler

    plug(:match)

    plug(Plug.Parsers,
        parsers: [:json],
        pass: ["application/json"],
        json_decoder: Poison
    )

    plug (:dispatch)


    get "/" do
        from = if (!conn.params["from"]), do: "0", 
                                            else: conn.params["from"]
        to = if (!conn.params["to"]), do: DateTime.to_unix(DateTime.utc_now()) |> Integer.to_string, 
                                        else: conn.params["to"]
                                        
        list = Enum.map(SiteVisit.DB.get(from, to), fn(s) -> 
            hd String.split(s,"#")
        end) |> Enum.uniq
                  
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(message(list,"ok")))
    end

    defp message(list, status) do
        %{
            domains: list,
            status: status
        }
    end

    defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack} = err) do
        conn
        |> send_resp(conn.status, Poison.encode!(message([],err.kind)))     
    end

end