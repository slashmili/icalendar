defmodule ICalendar.EventTest do
  use ExUnit.Case

  alias ICalendar.Event

  test "ICalendar.to_ics/1 of event" do
    ics = %Event{dtstamp: ~U[2015-12-24 08:45:00Z]} |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T084500Z
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with some attributes" do
    ics =
      %Event{
        summary: "Going fishing",
        description: "Escape from the world. Stare at some water.",
        comment: "Don't forget to take something to eat !",
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           COMMENT:Don't forget to take something to eat !
           DESCRIPTION:Escape from the world. Stare at some water.
           DTSTAMP:20151224T084500Z
           SUMMARY:Going fishing
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with date start and end" do
    ics =
      %Event{
        dtstart: DateTimeHelper.to_date({2015, 12, 24}),
        dtend: DateTimeHelper.to_date({2015, 12, 24}),
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTEND:20151224
           DTSTAMP:20151224T084500Z
           DTSTART:20151224
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with datetime start and end" do
    ics =
      %Event{
        dtstart: DateTimeHelper.to_datetime({{2015, 12, 24}, {8, 30, 00}}),
        dtstamp: ~U[2015-12-24 08:00:00Z],
        dtend: DateTimeHelper.to_datetime({{2015, 12, 24}, {8, 45, 00}})
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTEND:20151224T084500Z
           DTSTAMP:20151224T080000Z
           DTSTART:20151224T083000Z
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with datetime with timezone" do
    dtstart =
      {{2015, 12, 24}, {8, 30, 00}}
      |> DateTimeHelper.to_datetime("America/Chicago")

    dtend =
      {{2015, 12, 24}, {8, 45, 00}}
      |> DateTimeHelper.to_datetime("America/Chicago")

    ics =
      %Event{dtstart: dtstart, dtend: dtend, dtstamp: ~U[2015-12-24 08:45:00Z]}
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTEND;TZID=America/Chicago:20151224T084500
           DTSTAMP:20151224T084500Z
           DTSTART;TZID=America/Chicago:20151224T083000
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 does not damage url in description" do
    ics =
      %Event{
        summary: "Going fishing",
        description:
          "See this link http://example.com/pub" <>
            "/calendars/jsmith/mytime.ics",
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DESCRIPTION:See this link http://example.com/pub/calendars/jsmith/mytime.ics
           DTSTAMP:20151224T084500Z
           SUMMARY:Going fishing
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with url" do
    ics =
      %Event{
        url: "http://example.com/pub/calendars/jsmith/mytime.ics",
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T084500Z
           URL:http://example.com/pub/calendars/jsmith/mytime.ics
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with integer UID" do
    ics =
      %Event{
        uid: 815,
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T084500Z
           UID:815
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with string UID" do
    ics =
      %Event{
        uid: "0815",
        dtstamp: ~U[2015-12-24 08:00:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T080000Z
           UID:0815
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with geo" do
    ics =
      %Event{
        geo: {43.6978819, -79.3810277},
        dtstamp: ~U[2015-12-24 08:00:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T080000Z
           GEO:43.6978819;-79.3810277
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with categories" do
    ics =
      %Event{
        categories: ["Fishing", "Nature", "Sport"],
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           CATEGORIES:Fishing,Nature,Sport
           DTSTAMP:20151224T084500Z
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with status" do
    ics =
      %Event{
        status: :tentative,
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           DTSTAMP:20151224T084500Z
           STATUS:TENTATIVE
           END:VEVENT
           """
  end

  test "ICalendar.to_ics/1 with class" do
    ics =
      %Event{
        class: :private,
        dtstamp: ~U[2015-12-24 08:45:00Z]
      }
      |> ICalendar.to_ics()

    assert ics == """
           BEGIN:VEVENT
           CLASS:PRIVATE
           DTSTAMP:20151224T084500Z
           END:VEVENT
           """
  end
end
