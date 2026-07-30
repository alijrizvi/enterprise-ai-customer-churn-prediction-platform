# =========================================================
# ENTERPRISE MLOPS
# =========================================================
#
# File:
# 06_01_enterprise_mlops.py
#
# Purpose
# -------
# Transition a trained Machine Learning model into
# a production-ready artifact.
#
# This notebook demonstrates a lightweight MLOps
# workflow including:
#
# • Loading production artifacts
# • Model versioning
# • Logging
# • Configuration management
# • Data validation
# • Batch inference preparation
#
# Rather than training a model,
# MLOps focuses on deploying,
# maintaining,
# monitoring,
# and reusing models.
#
# =========================================================



# =========================================================
# 1. IMPORT LIBRARIES
# =========================================================

import os
import json
import logging
from pathlib import Path
from datetime import datetime

import joblib
import numpy as np
import pandas as pd



# =========================================================
# 2. CONFIGURATION
# =========================================================
#
# Keep configuration separate from business logic.
# This makes the code easier to maintain and reuse.
#
# =========================================================

PROJECT_NAME = "Enterprise Retail Decision Intelligence"

MODEL_NAME = "Retail Customer Value Predictor"

MODEL_VERSION = "1.0.0"

MODEL_OWNER = "Ali Jazib"

TARGET_VARIABLE = "high_value_customer"

MODEL_DIRECTORY = Path("../models")

DATA_DIRECTORY = Path("../data")

OUTPUT_DIRECTORY = Path("../outputs")

LOG_DIRECTORY = Path("../logs")

METADATA_DIRECTORY = Path("../metadata")



# =========================================================
# 3. CREATE OUTPUT DIRECTORIES
# =========================================================

OUTPUT_DIRECTORY.mkdir(exist_ok=True)

LOG_DIRECTORY.mkdir(exist_ok=True)

METADATA_DIRECTORY.mkdir(exist_ok=True)



# =========================================================
# 4. LOGGING
# =========================================================
#
# Logging records important workflow events.
# Production systems rely heavily on logs for
# monitoring and debugging.
#
# =========================================================

logging.basicConfig(

    filename=LOG_DIRECTORY / "mlops_pipeline.log",

    level=logging.INFO,

    format="%(asctime)s | %(levelname)s | %(message)s"

)

logger = logging.getLogger(__name__)

logger.info("Enterprise MLOps pipeline initialized.")



# =========================================================
# 5. LOAD PRODUCTION ARTIFACTS
# =========================================================
#
# Production systems load previously trained models
# instead of retraining them.
#
# =========================================================

logger.info("Loading production artifacts...")

gold_df = pd.read_csv(

    DATA_DIRECTORY / "gold_ml_customer_features.csv"

)

prediction_df = pd.read_csv(

    OUTPUT_DIRECTORY / "customer_predictions_explained.csv"

)

model = joblib.load(

    MODEL_DIRECTORY / "best_model.pkl"

)

logger.info("Production artifacts loaded successfully.")



# =========================================================
# 6. MODEL METADATA
# =========================================================
#
# Lightweight Model Registry.
# Stores key information about the production model.
#
# =========================================================

model_metadata = {

    "project": PROJECT_NAME,

    "model_name": MODEL_NAME,

    "version": MODEL_VERSION,

    "owner": MODEL_OWNER,

    "algorithm": "XGBoost",          # Modify if needed

    "target": TARGET_VARIABLE,

    "training_dataset": "gold_ml_customer_features.csv",

    "created": str(datetime.now()),

    "status": "Production"

}



with open(

    METADATA_DIRECTORY / "model_metadata.json",

    "w"

) as file:

    json.dump(

        model_metadata,

        file,

        indent=4

    )

logger.info("Model metadata saved.")



# =========================================================
# 7. DATA VALIDATION
# =========================================================
#
# Validate inputs before making predictions.
# This prevents many production failures.
#
# =========================================================

required_columns = [

    "customer_id",

    "recency",

    "frequency",

    "monetary_value"

]



def validate_input_data(df):

    """
    Validate production input data.
    """

    logger.info("Running input validation...")

    if df.empty:

        raise ValueError("Input dataframe is empty.")

    missing = [

        column

        for column in required_columns

        if column not in df.columns

    ]

    if missing:

        raise ValueError(

            f"Missing columns: {missing}"

        )

    duplicates = df["customer_id"].duplicated().sum()

    if duplicates > 0:

        logger.warning(

            f"{duplicates} duplicate customer IDs detected."

        )

    logger.info("Validation completed successfully.")

    return True



validate_input_data(gold_df)



# =========================================================
# 8. PREPARE FEATURES
# =========================================================
#
# Remove non-feature columns before prediction.
# Adjust this section based on your final model.
#
# =========================================================

feature_columns = [

    column

    for column in gold_df.columns

    if column not in [

        "customer_id",

        TARGET_VARIABLE

    ]

]

X_production = gold_df[feature_columns]

logger.info("Production features prepared.")



# =========================================================
# END OF PART 1
# =========================================================
#
# Completed
#
# ✓ Configuration
# ✓ Logging
# ✓ Loading production artifacts
# ✓ Metadata
# ✓ Validation
# ✓ Feature preparation
#
# Next:
#
# • Prediction functions
# • Batch inference
# • Saving outputs
# • Monitoring
# • MLOps summary
#
# =========================================================


# Enterprise MLOps Overview

# Purpose:
# Deploy a trained ML model into a reusable production workflow.


# Import Libraries

import joblib
import pandas as pd
import json
from pathlib import Path
from datetime import datetime


# Load Production Artifacts

model = joblib.load("../models/best_model.pkl")
gold_df = pd.read_csv("../data/gold_ml_customer_features.csv")


# Configuration

MODEL_NAME = "Retail Customer Value Predictor"
MODEL_VERSION = "1.0"
OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)


# Metadata

metadata = {
    "model": MODEL_NAME,
    "version": MODEL_VERSION,
    "created": str(datetime.now())
}

with open("../outputs/model_metadata.json","w") as f:
    json.dump(metadata, f, indent=4)


# Prediction Function

def predict_customers(model, df):

    X = df.drop(columns=["customer_id","high_value_customer"])

    df["prediction"] = model.predict(X)

    if hasattr(model, "predict_proba"):
        df["probability"] = model.predict_proba(X)[:,1]

    return df


# Batch Inference

production_predictions = predict_customers(model, gold_df.copy())


# Save Outputs

production_predictions.to_csv(
    "../outputs/customer_predictions.csv",
    index=False
)


# Monitoring Summary

summary = {
    "Customers": len(production_predictions),
    "High Risk":
        int(production_predictions["prediction"].sum()),
    "Average Probability":
        round(
            production_predictions["probability"].mean(),
            3
        )
}

print(summary)


# Notebook Summary

print("""
Enterprise MLOps Pipeline Completed

✓ Loaded production model
✓ Performed batch inference
✓ Saved predictions
✓ Saved model metadata
✓ Generated monitoring summary

Future Improvements:
• MLflow
• FastAPI
• Docker
• CI/CD
""")