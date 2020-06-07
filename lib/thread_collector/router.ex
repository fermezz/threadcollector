defmodule ThreadCollector.Router do
  use Plug.Router

  require Logger

  alias ThreadCollector.Slack
  alias ThreadCollector.CollectedNotes

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:match)
  plug(:dispatch)

  post "/" do
    channel_id = conn.body_params["channel_id"]
    params = String.split(conn.body_params["text"])

    [limit, title] =
      case Enum.count(params) do
        1 ->
          List.insert_at(params, 1, "No Title, Change Me")

        _ ->
          [
            params |> List.first(),
            params |> Enum.drop(1) |> Enum.join(" ")
          ]
      end

    Task.start(fn ->
      with {:ok, messages} <- Slack.retrieve_channel_history(channel_id, limit),
           {:ok, note_url} <- CollectedNotes.create_note(messages, title) do
        Slack.post_message(channel_id, "Note created at " <> note_url)
      end
    end)

    send_resp(conn, 200, "Working on it!")
  end
end
