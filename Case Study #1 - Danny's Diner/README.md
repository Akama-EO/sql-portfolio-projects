# :ramen: :curry: :sushi: Case Study #1: Danny's Diner 
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="450" height="450">

You can find the complete the case study [here](https://8weeksqlchallenge.com/case-study-1/)

## Table of Contents
  - [Introduction](#introduction)
  - [Problem Statement](#problem-statement)
  - [Datasets used](#datasets-used)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Questions](#case-study-questions)
  
## Introduction
Danny seriously loves Japanese food, so in the beginning of 2021 he decided to embark upon a risky venture to open up a cute little restaurant, Danny’s Diner, that sells his 3 favourite foods: sushi, curry and ramen.

Danny needs your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans to use the insights from customer data to help him decide whether he should expand the existing customer loyalty program.

## Datasets used
Three key datasets for this case study
- sales: The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
- menu: The menu table maps the product_id to the actual product_name and price of each menu item.
- members: The members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

## Entity Relationship Diagram
![alt text](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/ERD.jpg)

## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
10. What is the total items and amount spent for each member before they became a member?
11. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
12. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  
Click [here](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Danny's%20Diner%20Solution.md) to view the solution solution of the case study!

NB: Queries for this case study was implemented in both [MySQL](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Danny's%20Diner%20Solution%20(MySQL%20v8.4).sql) and [Microsoft SQL Server](https://github.com/Akama-EO/sql-portfolio-projects/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Danny's%20Diner%20Solution%20(SQL%20Server%20v19.4).sql).
