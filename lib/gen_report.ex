defmodule GenReport do
  alias GenReport.Parser

  @workers [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp sum_values([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month =
      Map.put(hours_per_month, name, sum_months(hours_per_month, name, hours, month))

    hours_per_year = Map.put(hours_per_year, name, sum_years(hours_per_year, name, hours, year))

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_years(hours_per_year, name, hours, year) do
    Map.put(hours_per_year[name], year, hours_per_year[name][year] + hours)
  end

  defp sum_months(hours_per_month, name, hours, month) do
    Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
  end

  defp report_acc() do
    all_hours = Enum.into(@workers, %{}, &{&1, 0})
    months = Enum.into(@months, %{}, &{&1, 0})
    hours_per_month = Enum.into(@workers, %{}, &{&1, months})
    years = Enum.into(@years, %{}, &{&1, 0})
    hours_per_year = Enum.into(@workers, %{}, &{&1, years})

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
