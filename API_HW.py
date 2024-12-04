import requests
import pandas as pd
import matplotlib.pyplot as plt

API_KEY = "api key"
BASE_URL_QUOTE = "https://yfapi.net/v6/finance/quote"
BASE_URL_TRENDING = "https://yfapi.net/v1/finance/trending/US"
BASE_URL_HISTORICAL = "https://yfapi.net/v8/finance/spark"
HEADERS = {
    "X-API-KEY": API_KEY,
    "Accept": "application/json"
}

ticker = input("Enter the stock ticker symbol: ").strip().upper()

params = {"symbols": ticker}
response = requests.get(BASE_URL_QUOTE, headers=HEADERS, params=params)

if response.status_code == 200:
    try:
        stock_data = response.json()
        if "quoteResponse" in stock_data and "result" in stock_data["quoteResponse"]:
            result = stock_data["quoteResponse"]["result"][0]
            ticker_name = result["symbol"]
            full_name = result.get("longName", "N/A")
            current_price = result.get("regularMarketPrice", "N/A")
            target_mean_price = result.get("targetMeanPrice", "N/A")
            high_52_week = result.get("fiftyTwoWeekHigh", "N/A")
            low_52_week = result.get("fiftyTwoWeekLow", "N/A")

            print(f"\nTicker: {ticker_name}")
            print(f"Full Name: {full_name}")
            print(f"Current Market Price: ${current_price}")
            print(f"Target Mean Price: ${target_mean_price}")
            print(f"52-Week High: ${high_52_week}")
            print(f"52-Week Low: ${low_52_week}")

            stock_df = pd.DataFrame([{
                "Ticker": ticker_name,
                "Full Name": full_name,
                "Current Market Price": current_price,
                "Target Mean Price": target_mean_price,
                "52-Week High": high_52_week,
                "52-Week Low": low_52_week
            }])
            stock_df.to_csv("stock_data.csv", index=False)
            print("\nStock data saved to 'stock_data.csv'.")
        else:
            print("No data found for the given ticker.")
            exit()
    except Exception as e:
        print(f"Error processing stock data: {e}")
        exit()
else:
    print(f"Error fetching stock data: {response.status_code}")
    exit()

response_trending = requests.get(BASE_URL_TRENDING, headers=HEADERS)
if response_trending.status_code == 200:
    try:
        trending_data = response_trending.json()
        trending_stocks = [
            item["symbol"] for item in trending_data["finance"]["result"][0]["quotes"][:5]
        ]
        print("\nTop 5 Trending Stocks:")
        print(", ".join(trending_stocks))
    except Exception as e:
        print(f"Error processing trending stocks: {e}")
else:
    print(f"Error fetching trending stocks: {response_trending.status_code}")

print("\nFetching historical data for the last 5 days...")
historical_params = {
    "symbols": ticker,
    "range": "5d",
    "interval": "1d"
}
response_historical = requests.get(BASE_URL_HISTORICAL, headers=HEADERS, params=historical_params)

print(response_historical.status_code)

if response_historical.status_code == 200:
    try:
        historical_data = response_historical.json()[ticker]
        timestamps = historical_data["timestamp"]
        high_prices = historical_data["high"]

        dates = pd.to_datetime(timestamps, unit='s').strftime('%Y-%m-%d')

        # Plot data
        plt.figure(figsize=(10, 5))
        plt.plot(dates, high_prices, marker='o')
        plt.title(f"{ticker_name} - Historical High Prices (Last 5 Days)")
        plt.xlabel("Date")
        plt.ylabel("Price ($)")
        plt.grid()
        plt.show()
    except Exception as e:
        print(f"Error processing historical data: {e}")
else:
    print(f"Error fetching historical data: {response_historical.status_code}")
