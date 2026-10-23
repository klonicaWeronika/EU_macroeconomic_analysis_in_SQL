# European Macroeconomic Analysis in T-SQL

SQL project analysing GDP, public debt, government expenditure and consumption of 30 European countries (2012–2023), built in **T-SQL (Microsoft SQL Server)**.

Course project for *Business Reports in SQL*, University of Gdańsk, 2024.

## Questions the project answers

| View | Question |
|---|---|
| `Poland` | How did Poland's GDP and public debt change over time? |
| `Debt_as_a_percent_of_GDP_in_2023` | What was each country's public debt as a share of GDP in 2023? |
| `Countires_with_biggest_GDP_in_2023` | Which 10 countries had the largest GDP in 2023? |
| `Countries_with_greater_debt_than_gdp_in_2017` | Which countries had public debt higher than GDP in 2017? |
| `Difference_in_GDP_between_2012_and_2023_by_country` | How much did each country's GDP change between 2012 and 2023? |
| `GDP_for_countries_across_years` | GDP of each country, one column per year (PIVOT). |
| `GDP_year_to_year_change_for_countries_across_years` | What was the year-over-year GDP change for each country? |
| `Expenditure_as_a_percent_of_GDP_across_years` | How large was government expenditure relative to GDP, by country and year (PIVOT)? |
| `Highest_consumption_as_a_percent_of_GDP_across_years` | Which country had the highest consumption-to-GDP ratio in each year? |

## SQL techniques used

- Views (`CREATE VIEW`)
- Joins, including a self-join (GDP 2012 vs. 2023)
- `PIVOT` to turn years into columns
- Window function `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` for the top country per year
- Subqueries and derived tables
- `TOP`, `ORDER BY`, `FORMAT` for percentage output
- Ratio calculations (debt/GDP, expenditure/GDP, consumption/GDP, year-over-year change)

## Data

| Table | Content | Years |
|---|---|---|
| `country` | Country names and ISO codes | n/a |
| `gdp` | GDP by country and year | 2012–2023 |
| `public_debt` | Public debt by country and year | [UZUPEŁNIJ] |
| `government_expenditure` | Government expenditure by country and year | 2014–2023 |
| `consumption` | Consumption by country and year | 2012–2023 |

- **Coverage:** 30 countries (EU member states plus Iceland, Norway and Switzerland).
- **Source:** Eurostat

**Data gaps:** `government_expenditure` has no value for Denmark in 2020 and none for Switzerland in 2023. Ratios involving these records are missing for those years.

## Possible extensions

- Keep ratios numeric inside views and format them only in the final output, so that sorting is correct.
- Add a CTE-based query, for example countries where expenditure/GDP rose three years in a row.
- Visualise the results in Power BI or Python.
