defmodule SiteVisit.EndpointTest do
    use ExUnit.Case
    use Plug.Test
  
    alias SiteVisit.Endpoint
  
    @opts Endpoint.init([])
    @content %{
                "links": [
                    "test.test"
                    ],
                "test": ["1"]
              }
    @content_faild %{
                "abc": [
                    "abc.abc"
                    ]
              }
  
    test "returns domains 200" do
      conn =
        conn(:get, "/visited_domains", "")
        |> Endpoint.call(@opts)
  
      assert conn.state == :sent
      assert conn.status == 200
    end
  
    test "upload links 201" do
      conn =
        conn(:post, "/visited_links", Poison.encode!(@content))
        |> put_req_header("content-type", "application/json")
        |> Endpoint.call(@opts)
  
      assert conn.state == :sent
      assert conn.status == 201
    end

    test "not found links 404" do
      conn =
        conn(:post, "/visited_links",  Poison.encode!(@content_faild))
        |> put_req_header("content-type", "application/json")
        |> Endpoint.call(@opts)
  
      assert conn.state == :sent
      assert conn.status == 404
    end
  
    test "returns 404" do
      conn =
        conn(:get, "/missing", "")
        |> Endpoint.call(@opts)
  
      assert conn.state == :sent
      assert conn.status == 404
    end

  end