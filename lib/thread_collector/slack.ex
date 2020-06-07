defmodule ThreadCollector.Slack do
  @slack_api_base_url "https://slack.com/api/"
  @conversations_history_api "conversations.history"

  def retrieve_channel_history(channel_id, limit \\ 10) do
    with {:ok, result} <-
           (@slack_api_base_url <> @conversations_history_api)
           |> URI.parse()
           |> Map.put(:query, URI.encode_query(%{"channel" => channel_id, "limit" => limit}))
           |> URI.to_string()
           |> Mojito.get([{"Authorization", "Bearer " <> System.get_env("SLACK_API_TOKEN")}]) do
      {
        :ok,
        result.body
        |> Jason.decode!()
        |> Map.get("messages")
        |> Enum.filter(fn message -> Map.get(message, "subtype") != "channel_join" end)
        |> Enum.reverse()
        |> Enum.map_join("\n", fn %{"text" => message} -> message end)
      }
    end
  end
end
