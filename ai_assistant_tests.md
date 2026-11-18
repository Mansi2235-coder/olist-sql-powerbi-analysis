# AI assistant for the Olist data (Claude Project)

I built a small AI assistant in a Claude Project. It answers questions about the Olist analysis using only my project files: `README.md`, `olist_queries.sql`, `data_quality_checks.sql` and the result tables (`KPIS`, `deliveries_reviews`, `monthly_revenue`, `revenue_by_state`, `top_categories`).

## Instructions

> You are a data assistant for the Olist e-commerce analysis project. Answer questions about orders, deliveries, reviews and customers using only the uploaded files (README, SQL queries, result tables). If the answer is not in the files, say you don't know. Always give the number, the source file, and one sentence of meaning. Keep answers short. If a question is unclear, ask one clarifying question.

## Test 1: six questions

| # | Question | Answer given | Correct? |
|---|---|---|---|
| 1 | How many orders are in the dataset? | 99,441 | Yes |
| 2 | What share of orders were delivered late? | 8.1% | Yes |
| 3 | How much lower are the reviews for late deliveries? | 1.72 points lower (2.57 vs 4.29) | Yes |
| 4 | Which SQL query finds late deliveries? | Query 3 in `olist_queries.sql` | Yes |
| 5 | What is the average review score by delivery status? | Late 2.57 (7,700 orders), on time 4.29 (88,653 orders) | Yes |
| 6 | What was the total revenue in 2030? | "I don't know", the data covers 2016 to 2018 | Yes (correct refusal) |

All six answers were correct. The problem was length: several answers were longer than "short" and added caveats that nobody asked for.

## Change

I added one line to the instructions:

> Answer in at most three sentences. Give the number first, then the source file. Only mention causation or caveats when the question asks about causes.

## Test 2: re-test after the change

I asked questions 1, 3 and 5 again. The numbers were the same (99,441 orders; 1.72 points lower; late 2.57 and on time 4.29), and the answers were shorter, with the source file named each time.
