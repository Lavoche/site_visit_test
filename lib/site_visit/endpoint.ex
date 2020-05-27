defmodule SiteVisit.Endpoint do
    use Plug.Router

    plug(:match)
    
    plug(:dispatch)


    forward("/visited_links", to: SiteVisit.LinksRouter)

    forward("/visited_domains", to: SiteVisit.DomainsRouter)


    match _ do 
        send_resp(conn, 404, "Requestes page not found!")
    end

end