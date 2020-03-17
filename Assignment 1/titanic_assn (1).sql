/*  DBase Assn 1: Danish Faruqi

    Passengers on the Titanic:
        1,503 people died on the Titanic.
        - around 900 were passengers, 
        - the rest were crew members.

    This is a list of what we know about the passengers.
    Some lists show 1,317 passengers, 
        some show 1,313 - so these numbers are not exact, 
        but they will be close enough that we can spot trends and correlations.

    Lets' answer some questions about the passengers' survival data: 
 */

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in section below after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*  Create the table and get data into it: */

DROP TABLE IF EXISTS passengers;

CREATE TABLE passengers (
    id INTEGER NOT NULL,
    lname TEXT,
    title TEXT,
    class TEXT, 
    age FLOAT,
    sex TEXT,
    survived INTEGER,
    code INTEGER
);

-- Now get the data into the database:
\COPY passengers FROM './titanic.csv' WITH (FORMAT csv);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in the above section after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/* Some queries to get you started:  */


-- -- How many total passengers?:
-- SELECT COUNT(*) AS total_passengers FROM passengers;



-- -- How many survived?
-- SELECT COUNT(*) AS survived FROM passengers WHERE survived=1;


-- -- How many died?
-- SELECT COUNT(*) AS did_not_survive FROM passengers WHERE survived=0;


-- -- How many were female? Male?
-- SELECT COUNT(*) AS total_females FROM passengers WHERE sex='female';
-- SELECT COUNT(*) AS total_males FROM passengers WHERE sex='male';


-- -- How many total females died?  Males?
-- SELECT COUNT(*) AS no_survived_females FROM passengers WHERE sex='female' AND survived=0;
-- SELECT COUNT(*) AS no_survived_males FROM passengers WHERE sex='male' AND survived=0;


-- -- Percentage of females of the total?
-- SELECT 
--     SUM(CASE WHEN sex='female' THEN 1.0 ELSE 0.0 END) / 
--         CAST(COUNT(*) AS FLOAT)*100 
--             AS tot_pct_female 
-- FROM passengers;


-- -- Percentage of males of the total?
-- SELECT 
--     SUM(CASE WHEN sex='male' THEN 1.0 ELSE 0.0 END) / 
--         CAST(COUNT(*) AS FLOAT)*100 
--             AS tot_pct_male 
-- FROM passengers;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Write queries that will answer the following questions:  %%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-- 1.  What percent of passengers survived? (total)

SELECT
    SUM(
        CASE WHEN survived = '1' THEN 1.0 ELSE 0.0 END 
        )/
    CAST(COUNT(*) AS FLOAT)*100
        AS total_passenger_survival_rate
FROM passengers;

-- 2.  What percentage of females survived?     (female_survivors / tot_females)
    
SELECT 
    SUM(
        CASE WHEN sex = 'female' AND survived = '1' THEN 1.0 ELSE 0.0 END    
        )/
    CAST(SUM (CASE WHEN sex = 'female' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100
        AS percentage_of_survived_females 

FROM
    passengers;
   


-- 3.  What percentage of males that survived?      (male_survivors / tot_males)
SELECT 
    SUM(
        CASE WHEN sex = 'male' AND survived = '1' THEN 1.0 ELSE 0.0 END    
        )/
    CAST(SUM (CASE WHEN sex = 'male' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100
        AS percentage_of_survived_males 

FROM
    passengers; 



-- 4.  How many people total were in First class, Second class, Third class, or of class unknown ?
SELECT
    SUM(
        CASE WHEN class = '1st' THEN 1 ELSE 0 END
        ) AS first_class,
    SUM(
        CASE WHEN class = '2nd' THEN 1 ELSE 0 END 
       ) AS second_class,
    SUM(
        CASE WHEN class = '3rd' THEN 1 ELSE 0 END 
        ) AS third_class,
    SUM(CASE WHEN class IS NULL THEN 1 ELSE 0 END
        ) AS unknown_class
FROM 
    passengers;



-- 5.  What is the total number of people in First and Second class ?

SELECT COUNT(*) AS total_first_and_second_class FROM passengers WHERE class = '1st' OR class = '2nd';  
-- SELECT 
--     SUM( CASE WHEN 

--         )+ 
--     SUM(
--         ) AS total_first_and_second_class
-- FROM 
--     passengers;


-- 6.  What are the survival percentages of the different classes? (3).
SELECT 
    SUM(
        CASE WHEN class = '1st' AND survived = '1' THEN 1 ELSE 0 END )/ 
            CAST(SUM(CASE WHEN class = '1st' THEN 1.0 ELSE 0.0 END)AS FLOAT) *100
                AS percent_of_survived_1st_class, 

    SUM(
        CASE WHEN class = '2nd' AND survived = '1' THEN 1.0 ELSE 0.0 END )/
            CAST(SUM (CASE WHEN class = '2nd' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100
                AS percent_of_survived_2nd_class, 

    SUM(
        CASE WHEN class = '3rd' AND survived = '1' THEN 1.0 ELSE 0.0 END )/
            CAST(SUM (CASE WHEN class = '3rd' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100
                AS percent_of_survived_3rd_class
FROM 
    passengers;     



-- 7.  Can you think of other interesting questions about this dataset?
--      I.e., is there anything interesting we can learn from it?  
--      Try to come up with at least two new questions we could ask.

--      Example:
--      Can we calcualte the odds of survival if you are a female in Second Class?

--      Could we compare this to the odds of survival if you are a female in First Class?
--      If we can answer this question, is it meaningful?  Or just a coincidence ... ?

        

            -- Answer:
            -- How many chidren where there on board and what was the survival rate for each class? ( not counting unknown)

            -- This question may help us understand if one's economic status applied to age at times of crisis aswell



-- 8.  Can you answer the questions you thought of above?
--      Are you able to write the query to find the answer now? 
SELECT

    SUM(CASE WHEN age < 18.0 AND survived = 1 THEN 1 ELSE 0 END

        ) AS total_kids_survived,


 

    SUM(CASE WHEN age < 18.0 AND survived = 1 THEN 1 ELSE 0 END)/

        CAST(SUM(CASE WHEN age <18.0 THEN 1 ELSE 0 END) AS FLOAT) * 100

        AS total_kids_survival_rate,


 

    SUM(CASE WHEN age < 18.0 AND survived = 1 AND class = '1st' THEN 1 ELSE 0 END)/

        CAST(SUM(CASE WHEN age < 18.0 AND class = '1st' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100

        AS total_1st_class_surival_rate,


 

    SUM(CASE WHEN age < 18.0 AND survived = 1 AND class = '2nd' THEN 1 ELSE 0 END)/

        CAST(SUM(CASE WHEN age < 18.0 AND class = '2nd' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100

        AS total_2nd_class_surival_rate,


 

    SUM(CASE WHEN age < 18.0 AND survived = 1 AND class = '3rd' THEN 1 ELSE 0 END)/

        CAST(SUM(CASE WHEN age < 18.0 AND class = '3rd' THEN 1.0 ELSE 0.0 END) AS FLOAT) *100

        AS total_3rd_class_surival_rate

FROM

    passengers;


 


 


 

-- 9.  If someone asserted that your results for Question #8 were incorrect,

--     how could you defend your results, and verify that they are indeed correct?


 


 


 

    -- My results are simple, to find the percentage of kids that survived for each class

    -- I check for age, class, and that they survived divided by age and class,

    -- this way for each class I calculate using (# of kids that are alive per class / #

    -- of kids from the class in total). You can verify by suing the formaula.  My results

    -- can be defended by individually calculating total # of kids that survived per class

    -- and dividing by the amount of kids in that class.


 


/*
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Email me ONLY this document - as an attachment.  You may just fill in your answers above.

    Do NOT send any other format except for one single .sql file.

    ZIP folders, word documents, and any other format (other than .sql) will receive zero credit.

    Do NOT copy and paste your queries into the body of the email.

    Your sql should run without errors - please test it beforehand.

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/


