create view Poland as 
select gdp.[Year], [name] as 'Country', gdp.country_iso as 'Country ISO', 
gdp.amount as 'GDP', [public_debt].amount as 'PUBLIC DEBT'
from country, GDP, public_debt
where gdp.country_iso = country.country_iso and gdp.country_iso = public_debt.country_iso
and gdp.[Year] = public_debt.[YEAR] and [name] = 'Poland'
order by [year] offset 0 rows;

create view Debt_as_a_percent_of_GDP_in_2023 as
select gdp.[Year], [name] as 'Country', gdp.country_iso as 'Country ISO',
format([public_debt].amount/gdp.amount, 'p') as 'Debt as a percent of GDP'
from country, GDP, public_debt
where gdp.country_iso = country.country_iso and gdp.country_iso = public_debt.country_iso
and gdp.[Year] = public_debt.[YEAR] and public_debt.[YEAR] = 2023;

create view Countires_with_biggest_GDP_in_2023 as
select top 10 [Year], [name] as 'Country', amount as 'GDP' from country, gdp
where gdp.country_iso = country.country_iso and [year] = 2023
order by amount desc;

create view Countries_with_greater_debt_than_gdp_in_2017 as
select gdp.[Year], [name] as 'Country', gdp.amount as 'GDP', [public_debt].amount as 'PUBLIC DEBT'
from country, GDP, public_debt
where gdp.country_iso = country.country_iso and gdp.country_iso = public_debt.country_iso
and gdp.[Year] = public_debt.[YEAR] and gdp.amount<public_debt.amount and gdp.[Year] = 2017;

create view Difference_in_GDP_between_2012_and_2023_by_country as 
select [Name], (a.amount - b.amount) as 'Difference in GDP between 2012 and 2023'
from gdp a
join country
on a.country_iso = country.country_iso
join gdp b
on a.country_iso = b.country_iso
where a.[year] = 2023 and b.[year] = 2012;

create view GDP_for_countries_across_years as 
select [Country], [Country ISO], [2012], [2013] ,[2014], [2015], [2016], [2017], [2018],
[2019], [2020], [2021], [2022], [2023]
from
(
   select gdp.[Year] as 'Year', [name] as 'Country', gdp.country_iso as 'Country ISO', 
	gdp.amount as 'GDP'
	from country, GDP, public_debt
	where gdp.country_iso = country.country_iso and gdp.country_iso = public_debt.country_iso
	and gdp.[Year] = public_debt.[YEAR] 
) as SourceTable
pivot
(
    MAX([GDP])
    for Year in ([2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021],[2022],[2023])
) as PivotTable;

create view GDP_year_to_year_change_for_countries_across_years as 
select Country, [Country ISO],
format(([2013]-[2012])/[2012], 'p') as 'Change 2012-2013',
format(([2014]-[2013])/[2013], 'p') as 'Change 2013-2014',
format(([2015]-[2014])/[2014], 'p') as 'Change 2014-2015',
format(([2016]-[2015])/[2015], 'p') as 'Change 2015-2016',
format(([2017]-[2016])/[2016], 'p') as 'Change 2016-2017',
format(([2018]-[2017])/[2017], 'p') as 'Change 2017-2018',
format(([2019]-[2018])/[2018], 'p') as 'Change 2018-2019',
format(([2020]-[2019])/[2019], 'p') as 'Change 2019-2020',
format(([2021]-[2020])/[2020], 'p') as 'Change 2020-2021',
format(([2022]-[2021])/[2021], 'p') as 'Change 2021-2022',
format(([2023]-[2022])/[2022], 'p') as 'Change 2022-2023'
from GDP_for_countries_across_years

create view Expenditure_as_a_percent_of_GDP_across_years as
select [Country], [Country ISO], [2014], [2015], [2016], [2017], [2018],
[2019], [2020], [2021], [2022], [2023]
from
(
	select gdp.[Year], [name] as 'Country', gdp.country_iso as 'Country ISO',
	format([government_expenditure].amount/gdp.amount, 'p') as 'percentage'
	from country, GDP, government_expenditure
	where gdp.country_iso = country.country_iso and gdp.country_iso = government_expenditure.country_iso
	and gdp.[Year] = government_expenditure.[YEAR]
) as SourceTable
pivot
(
    MAX([percentage])
    for Year in ([2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021],[2022],[2023])
) as PivotTable;

create view Highest_consumption_as_a_percent_of_GDP_across_years as
select groups.[Country], groups.[Country ISO], groups.Year, groups.percentage as 'Percentage' from
(
	select *, 
	ROW_NUMBER() over (partition by raw_data.[Year] order by raw_data.[percentage] desc) as row_number
	from 
	(
		select [name] as 'Country', gdp.country_iso as 'Country ISO', gdp.[Year],
		format(consumption.amount/gdp.amount, 'p') as 'percentage'
		from country, GDP, consumption
		where gdp.country_iso = country.country_iso and gdp.country_iso = consumption.country_iso
		and gdp.[Year] = consumption.[YEAR]
	) as raw_data
) as groups
where groups.row_number = 1

select*from Poland;
select*from Debt_as_a_percent_of_GDP_in_2023;
select*from Countires_with_biggest_GDP_in_2023;
select*from Countries_with_greater_debt_than_gdp_in_2017;
select*from Difference_in_GDP_between_2012_and_2023_by_country;
select*from GDP_for_countries_across_years;
select*from GDP_year_to_year_change_for_countries_across_years;
select TOP(1) Country, [Change 2012-2013] from GDP_year_to_year_change_for_countries_across_years order by [Change 2012-2013] desc --Country with the biggest growth year to year
select*from Expenditure_as_a_percent_of_GDP_across_years;
select*from Highest_consumption_as_a_percent_of_GDP_across_years;