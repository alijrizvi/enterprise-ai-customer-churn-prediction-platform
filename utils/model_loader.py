import joblib
import pandas as pd

def load_model():
    # It's unclear if you want to load all models or a specific one.
    # For demonstration, I'll return a dictionary of all models.
    # If you only need one, adjust the function to take a model_name argument.
    models = {
        "decision_tree": joblib.load("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Decision_Tree_Classifier_model.joblib"),
        "random_forest": joblib.load("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Random_Forest_Classifier_model.joblib"),
        "xgboost": joblib.load("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Gradient_Boosting_XGBoost_Classifier_model.joblib")
    }
    return models

def load_predictions():
    # Similar to models, it's unclear if you want all predictions or a specific one.
    # Returning a dictionary of DataFrames from each CSV.
    predictions = {
        "decision_tree_predictions": pd.read_csv("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Decision_Tree_Classifier_predictions.csv"),
        "random_forest_predictions": pd.read_csv("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Random_Forest_Classifier_predictions.csv"),
        "xgboost_predictions": pd.read_csv("/content/drive/MyDrive/Enterprise AI Customer Churn Prediction Platform/models/Gradient_Boosting_XGBoost_Classifier_predictions.csv")
    }
    return predictions