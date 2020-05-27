defmodule SiteVisit.DB do
    import Exredis
    
    def get(from, to), do: start_link |> elem(1) |> query(["ZRANGEBYSCORE", "site", from, to])
        

    def set(site, timestamp), do: start_link |> elem(1) |> query(["ZADD", "site", timestamp, site <> "#" <> timestamp])

end