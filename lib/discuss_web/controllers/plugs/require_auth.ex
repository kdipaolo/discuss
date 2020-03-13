defmodule Discuss.Plugs.RequireAuth do 
    import Plug.Conn
    import Phoenix.Controller     
    use DiscussWeb, :controller
    alias Discuss.Routes.Helpers

    def init(_params) do 
    
    end

    def call(conn, _params) do 
        if conn.assigns[:user] do 
            conn
        else
            conn 
            |> put_flash(:error, "You must be logged in.")
            |> redirect(to: Routes.topic_path(conn, :index))
            |> halt()
        end
    end   
end