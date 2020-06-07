defmodule ThreadCollector.CollectedNotes do
  @collected_notes_api_base_url "https://collectednotes.com/"

  def create_note(note_body, note_title) do
    with {:ok, result} <-
           (@collected_notes_api_base_url <>
              "sites/" <> System.get_env("COLLECTED_NOTES_SITE_ID") <> "/notes/")
           |> Mojito.post(
             [
               {"Authorization",
                System.get_env("COLLECTED_NOTES_EMAIL") <>
                  " " <> System.get_env("COLLECTED_NOTES_API_TOKEN")},
               {"Accept", "application/json"},
               {"Content-Type", "application/json"}
             ],
             Jason.encode!(%{
               "note" => %{"body" => "# " <> note_title <> "\n" <> note_body}
             })
           ) do
      {
        :ok,
        result.body
        |> Jason.decode!()
        |> Map.get("url")
      }
    end
  end
end
