"""
data_loader.py
Enterprise AI Customer Churn Prediction Platform

Production-ready data loading and preprocessing utilities.
"""

import pandas as pd
import numpy as np
import requests


GOLD_DATASET_URL = (
    "https://raw.githubusercontent.com/alijrizvi/"
    "enterprise-ai-customer-churn-prediction-platform/main/data/"
    "gold_ml-ready_customer-features.csv"
)


def load_customer_churn_data(url: str) -> pd.DataFrame:
    """
    Load customer churn dataset from a CSV URL.
    """
    try:
        df = pd.read_csv(url)
        print(f"✓ Successfully loaded {len(df):,} records.")
        return df

    except requests.exceptions.RequestException as e:
        print(f"Request Error: {e}")
        return pd.DataFrame()

    except Exception as e:
        print(f"Unexpected Error: {e}")
        return pd.DataFrame()


def clean_customer_churn_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Clean customer churn dataset.
    """

    if df.empty:
        return df

    string_columns = [
        "customerID",
        "customer_value_quintile",
        "multi_franchise_customer",
        "high_value_customer",
        "churn_label",
    ]

    for col in string_columns:
        if col in df.columns:
            df[col] = df[col].astype(str)

    df = df.fillna(0)
    df = df.drop_duplicates()

    return df


def load_gold_ml_dataset(sample_size=None) -> pd.DataFrame:
    """
    Load the production Gold dataset.
    """

    df = load_customer_churn_data(GOLD_DATASET_URL)

    if df.empty:
        return df

    df = clean_customer_churn_data(df)

    if sample_size is not None:
        return df.sample(sample_size, random_state=42)

    return df