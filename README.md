# 🦠 COVID-19 Data Analysis (SQL & Excel Project)
## 📌 Project Overview

This project explores global COVID-19 data using SQL and Excel. It focuses on understanding the relationship between cases, deaths, and vaccinations, as well as how the pandemic impacted different countries and regions.

The project demonstrates data exploration, cleaning, and analysis with excel and SQL.

### 🛠️ Tools & Skills Used

- Excel
- Data cleaning
- SQL Server (MySQL)
- Aggregate functions (SUM, MAX, AVG)
- Window functions (ROW_NUMBER, RANK)
- Joins, CTEs, and Temp Tables

### 📂 Datasets

The project uses two main datasets:
- CovidDeaths – Cases, deaths, population data by country and date
- CovidVaccinations – Vaccination counts by country and date

Key fields:
- Location – Country/region
- Date – Reporting date
- Total_cases, New_cases
- Total_deaths, New_deaths
- Population
- People_vaccinated, People_fully_vaccinated

### 📊 Key Analyses

Cases vs. Deaths
- Likelihood of dying if infected (e.g., Philippines).

Cases vs. Population
- Infection rate as % of population (e.g., Canada).

Countries with Highest Infection Rates
- Countries with the largest % of population infected.

Countries & Continents with Highest Death Counts
- Ranking based on death totals relative to population.

Global Trends
- Worldwide total cases and deaths, with calculated mortality rate.

Vaccinations vs. Population
- Rolling count of people vaccinated, shown as % of country population.
- Includes CTEs, Temp Tables, and Views for later visualization.

### Sample Query 
-- Percentage of population infected by country
SELECT Location, population, 
       MAX(total_cases) AS highest_infection_count, 
       MAX((CAST(total_cases AS FLOAT)/population))*100 AS percent_pop_infected
FROM CovidDeaths
GROUP BY Location, population
ORDER BY percent_pop_infected DESC;
### 🔮 Future Enhancements

- Build interactive dashboards in Tableau or Power BI.
- Add time-series visualizations (cases & vaccinations over time).
- Extend analysis into predictive modeling using Python.

### 🙋 About This Project

This project highlights my ability to:
- Work with large, real-world datasets
- Write complex SQL queries for data exploration
- Translate raw data into meaningful insights that can inform decisions
