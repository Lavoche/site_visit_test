defmodule SiteVisit.DBTest do
    use ExUnit.Case
    doctest SiteVisit.DB
  
    test "checking database connection" do
      assert SiteVisit.DB.get(1, 5) == []
    end
  end