-- Step 1: Create 100 Indian names
WITH indian_names AS (
  SELECT
    row_number() OVER () AS rn,
    first_name,
    last_name
  FROM (
    SELECT
      unnest(ARRAY[
        'Aarav', 'Vivaan', 'Aditya', 'Krishna', 'Rohan', 'Ishaan', 'Arjun', 'Dev', 'Kabir', 'Aryan',
        'Yuvan', 'Kartik', 'Tejas', 'Nihal', 'Harsh', 'Pranav', 'Siddharth', 'Rudra', 'Shaurya', 'Tanmay',
        'Om', 'Rajat', 'Tanish', 'Daksh', 'Hrithik', 'Neel', 'Uday', 'Bhavesh', 'Nakul', 'Tarun',
        'Ajay', 'Sahil', 'Deepak', 'Rajeev', 'Ankit', 'Gaurav', 'Chirag', 'Manish', 'Rahul', 'Sumeet',
        'Kunal', 'Naveen', 'Vivek', 'Pankaj', 'Rakesh', 'Saurabh', 'Varun', 'Amit', 'Sunil', 'Vinay',
        'Diya', 'Ananya', 'Isha', 'Saanvi', 'Meera', 'Kavya', 'Pooja', 'Sneha', 'Riya', 'Neha',
        'Aishwarya', 'Divya', 'Nikita', 'Preeti', 'Tanya', 'Bhavya', 'Shruti', 'Nandini', 'Charu', 'Ira',
        'Radha', 'Laxmi', 'Shalini', 'Rekha', 'Komal', 'Simran', 'Payal', 'Jaya', 'Priya', 'Swati',
        'Mira', 'Amrita', 'Sita', 'Usha', 'Rupali', 'Veena', 'Hemal', 'Kirti', 'Lavanya', 'Chhavi',
        'Asmita', 'Tara', 'Namrata', 'Mallika', 'Nisha', 'Anjali', 'Bharti', 'Padma', 'Seema', 'Gita'
      ]) AS first_name,
      unnest(ARRAY[
        'Sharma', 'Patel', 'Reddy', 'Nair', 'Mehta', 'Verma', 'Joshi', 'Mishra', 'Kumar', 'Gupta',
        'Singh', 'Chopra', 'Das', 'Rao', 'Iyer', 'Nambiar', 'Saxena', 'Kapoor', 'Banerjee', 'Ghosh',
        'Agarwal', 'Malhotra', 'Pandey', 'Bose', 'Kulkarni', 'Deshmukh', 'Naidu', 'Bhattacharya', 'Chatterjee', 'Menon',
        'Dey', 'Bhat', 'Dubey', 'Tripathi', 'Thakur', 'Yadav', 'Shetty', 'Mahajan', 'Khatri', 'Bansal',
        'Jain', 'Mittal', 'Goel', 'Seth', 'Tiwari', 'Srinivasan', 'Venkatesh', 'Gowda', 'Roy', 'Pal',
        'Joshi', 'Chaudhary', 'Chauhan', 'Pathak', 'Rawat', 'Rajput', 'Prajapati', 'Lal', 'Dev', 'Rathore',
        'Saxena', 'Bhatt', 'Gill', 'Bakshi', 'Mathur', 'Solanki', 'Nagpal', 'Sehgal', 'Ahluwalia', 'Kohli',
        'Kapadia', 'Sabharwal', 'Talwar', 'Nanda', 'Manocha', 'Grover', 'Kocchar', 'Behl', 'Arora', 'Sodhi',
        'Khanna', 'Kalra', 'Makhija', 'Suri', 'Sawhney', 'Chabbra', 'Khurana', 'Taneja', 'Wadhwa', 'Bagga',
        'Chadda', 'Bhasin', 'Bajaj', 'Ahmad', 'Iqbal', 'Hussain', 'Siddiqui', 'Ali', 'Khan', 'Syed'
      ]) AS last_name
  ) x
  LIMIT 100
),

-- Step 2: Generate row numbers for existing customers
target_customers AS (
  SELECT c.ctid,
         row_number() OVER (ORDER BY c.ctid) AS rn
  FROM sales.customer c
  LIMIT 100
),

-- Step 3: Join both sets by row number
joined_data AS (
  SELECT tc.ctid, tc.rn, i.first_name, i.last_name
  FROM target_customers tc
  JOIN indian_names i ON tc.rn = i.rn
)

-- Step 4: Perform update
UPDATE sales.customer c
SET
  --customerid = jd.rn,
  firstname = jd.first_name,
  lastname = jd.last_name
FROM joined_data jd
--WHERE customerid  = jd.ctid;
WHERE customerid  = jd.rn;
select * from sales.customer where  firstname is not null
 