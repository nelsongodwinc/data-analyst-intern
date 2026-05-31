import pandas as pd
import numpy as np
from google.colab import files

print("--- Generating & Cleaning Sales Data ---")
np.random.seed(46)
n = 1000

# Generating Data
products = ["Macbook Pro", "iPhone 14", "Washing Machine", "Flatscreen TV", "USB-C Cable", "AirPods", "iPad Air", "Samsung Galaxy S23", "Sony Headphones", "Dell XPS 15", "Apple Watch", "Nintendo Switch", "PlayStation 5", "Kindle Paperwhite", "Bluetooth Speaker"]
cities = ["Mumbai", "Delhi", "Bengaluru", "Hyderabad", "Ahmedabad", "Chennai", "Kolkata", "Surat", "Pune", "Jaipur", "Lucknow", "Kanpur"]
states = ["MH", "DL", "KA", "TG", "GJ", "TN", "WB", "RJ", "UP", "MP", "BR", "PB"]
payments = ["Credit Card", "PayPal", "Apple Pay", "Cash", "UPI", "Debit Card", "Net Banking", "Google Pay", "PhonePe", "Bank Transfer", "Cryptocurrency"]

df = pd.DataFrame({
    'Order ID': np.arange(100001, 100001+n),
    'Product': np.random.choice(products, n),
    'Quantity Ordered': np.random.randint(1, 10, n).astype(str),
    'Price Each (INR)': np.round(np.random.uniform(999.0, 150000.0, n), 2),
    'Order Date': pd.date_range(start='2023-01-01', periods=n, freq='5h').strftime('%m/%d/%Y %H:%M'),
    'Purchase Address': ['123 Main St' for _ in range(n)],
    'City': np.random.choice(cities, n),
    'State': np.random.choice(states, n),
    'Postal Code': np.random.randint(100000, 999999, n), 
    'Payment Method': np.random.choice(payments, n)
})

# Inject dirty data
df.loc[5:20, 'Quantity Ordered'] = 'Error' # Bad format hiding in numeric column
df.loc[200:220, 'Price Each (INR)'] = np.nan
df_dirty = pd.concat([df, df.iloc[:100]], ignore_index=True) 

# ==========================================
# INTERNSHIP TASK: DATA CLEANING OPERATIONS
# ==========================================
df_clean = df_dirty.copy()

# Step 5: Rename column headers to be clean and uniform (lowercase, no spaces)
df_clean.columns = df_clean.columns.str.strip().str.lower().str.replace(' ', '_').str.replace(r'[^a-zA-Z0-9_]', '', regex=True)

# Coerce 'Error' strings so they become NaNs that we can properly identify
df_clean['quantity_ordered'] = pd.to_numeric(df_clean['quantity_ordered'], errors='coerce')

# Step 1: Identify and handle missing values using .isnull()
if df_clean['quantity_ordered'].isnull().sum() > 0:
    df_clean['quantity_ordered'] = df_clean['quantity_ordered'].fillna(1) # Default qty to 1
if df_clean['price_each_inr'].isnull().sum() > 0:
    price_median = df_clean['price_each_inr'].median()
    df_clean['price_each_inr'] = df_clean['price_each_inr'].fillna(price_median)

# Step 2: Remove duplicate rows using .drop_duplicates()
df_clean = df_clean.drop_duplicates()

# Step 3: Standardize text values (Uppercase state codes for consistency)
df_clean['state'] = df_clean['state'].str.upper()

# Step 6: Check and fix data types (date as datetime, qty to int, price to float)
df_clean['order_date'] = pd.to_datetime(df_clean['order_date'])
df_clean['quantity_ordered'] = df_clean['quantity_ordered'].astype(int)
df_clean['price_each_inr'] = df_clean['price_each_inr'].astype(float)

# Step 4: Convert date formats to a consistent type (dd-mm-yyyy)
df_clean['order_date'] = df_clean['order_date'].dt.strftime('%d-%m-%Y')

# Display and Download
print(f"Final Shape: {df_clean.shape[0]} rows, {df_clean.shape[1]} columns")
filename = 'Sales_Data_Cleaned.csv'
df_clean.to_csv(filename, index=False)
files.download(filename)