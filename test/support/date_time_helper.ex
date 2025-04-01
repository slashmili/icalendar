defmodule DateTimeHelper do
  def to_datetime({date_t, time_t}, time_zone \\ "Etc/UTC") do
    date = Date.from_erl!(date_t)
    time = Time.from_erl!(time_t)

    date
    |> DateTime.new!(time, time_zone, Tzdata.TimeZoneDatabase)
  end

  def to_date({_, _, _} = date_tuple) do
    Date.from_erl!(date_tuple)
  end
end
