# ==========================================================
# Enterprise Decision Intelligence Platform
# Streamlit Application
# ==========================================================

import os
import json
import joblib
import pandas as pd
import numpy as np
from pathlib import Path

import streamlit as st
import plotly.express as px
import plotly.graph_objects as go

from dotenv import load_dotenv
from openai import OpenAI


# ==========================================================
# Page Configuration
# ==========================================================

st.set_page_config(
    page_title = "Enterprise AI | Customer Churn Predictor",
    page_icon = "⚡️",
    layout = "wide",
    initial_sidebar_state = "expanded"
)


# ==========================================================
# Load API Keys
# ==========================================================

load_dotenv()

client = OpenAI(api_key = os.getenv("OPENAI_API_KEY"))


# ==========================================================
# Paths
# ==========================================================

ROOT = Path("/Users/alijazibrizvi/Documents/Data Analytics/Project Management - Enterprise AI Customer Churn Prediction Platform")

MODEL_PATH       = ROOT / "models"   / "Gradient_Boosting_XGBoost_Classifier_model.joblib"
DATA_PATH        = ROOT / "data"     / "gold_ml-ready_customer-features.csv"
PREDICTIONS_PATH = ROOT / "outputs"  / "Gradient_Boosting_XGBoost_Classifier_predictions.csv"
METADATA_PATH    = ROOT / "metadata" / "metadata.json"


# ==========================================================
# Cached Loading
# ==========================================================

@st.cache_resource
def load_model():
    return joblib.load(MODEL_PATH)

@st.cache_data
def load_data():
    return pd.read_csv(DATA_PATH)

@st.cache_data
def load_predictions():
    return pd.read_csv(PREDICTIONS_PATH)

@st.cache_data
def load_metadata():
    with open(METADATA_PATH) as f:
        return json.load(f)


# ==========================================================
# Load Production Artifacts
# ==========================================================

model         = load_model()
gold_df       = load_data()
prediction_df = load_predictions()
metadata    = load_metadata()


# ==========================================================
# Agent Definitions (05_01_agentic_decision_intelligence.py)
# ==========================================================

AGENTS = {
    "analytics": """
You are a seasoned Retail Analytics professional with 
extensive experience in AI-augmented business intelligence.

Analyze KPIs.
Identify trends.
Summarize customer behaviour.
Only discuss descriptive analytics.

""",

    "machine_learning": """
You are a Senior Machine Learning Engineer.

Interpret model outputs.
Focus on predictive analytics.
Explain predictions.
Discuss feature importance.
Explain uncertainty.

""",

    "strategy": """
You are a Retail Strategy Consultant.
Convert analytical findings into business recommendations.
Focus on practical actions.

""",

    "executive": """
You are a Chief Decision Officer akin to a CEO.

Combine every agent's findings.
Write an executive report.
Communicate professionally.

"""
}


# ==========================================================
# Generic Agent Runner (05_01_agentic_decision_intelligence.py)
# ==========================================================

def run_agent(agent_name, user_request):
    response = client.chat.completions.create(
        model = "gpt-4.1-mini",
        messages = [
            {"role": "system", "content": AGENTS[agent_name]},
            {"role": "user",   "content": user_request}
        ],
        temperature = 0.2 # Level of Creativity
    )
    return response.choices[0].message.content


# ==========================================================
# Workflow Orchestrator (05_02_enterprise_ai_workflow.py)
# ==========================================================

def run_enterprise_workflow(user_request, dataset_summary, prediction_summary):
    """
    Runs the full 4-agent orchestrated workflow and returns
    all intermediate outputs + the final executive report.
    Analytics → ML → Strategy → Executive
    """
    enriched_request = f"""
Business Question:
{user_request}

Dataset Summary:
{dataset_summary}

Prediction Summary:
{prediction_summary}
"""
    analytics_output = run_agent("analytics",       enriched_request)
    ml_output        = run_agent("machine_learning", enriched_request)
    strategy_output  = run_agent("strategy", f"""
{analytics_output}

{ml_output}
""")
    executive_output = run_agent("executive", f"""
Analytics
{analytics_output}

Machine Learning
{ml_output}

Strategy
{strategy_output}
""")

    return {
        "analytics": analytics_output,
        "ml":        ml_output,
        "strategy":  strategy_output,
        "executive": executive_output,
    }


# ==========================================================
# Sidebar
# ==========================================================

with st.sidebar:
    st.markdown("## **Ali J. Rizvi**")
    st.markdown("""
        <div style="display: flex; gap: 16px; align-items: center; margin-top: 6px; margin-bottom: 6px;">
            <a href="https://github.com/alijrizvi" target="_blank" title="GitHub">
                <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg"
                    width="48" style="filter: invert(1); opacity: 1.0;"/>
            </a>
            <a href="https://www.linkedin.com/in/ali-jazib-rizvi" target="_blank" title="LinkedIn">
                <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linkedin.svg"
                    width="48" style="filter: invert(1); opacity: 1.0;"/>
            </a>
            <a href="https://medium.com/@alijrizvi" target="_blank" title="Medium Articles">
                <img src="https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/medium.svg"
                    width="48" style="filter: invert(1); opacity: 1.0;"/>
            </a>
        </div>
    """, unsafe_allow_html = True)

    st.divider()
    st.write("Model")
    st.sidebar.success(metadata["model_name"])

    st.sidebar.title("Enterprise AI Platform")
    page = st.sidebar.radio(
        "Navigation",
        [
            "Home",
            "Executive Dashboard",
            "Predict On Your Own!",
            "Enterprise AI Copilot",
            "Model Insights",
            "Project Documentation"
        ]
    )


# ==========================================================
# HOME
# ==========================================================

if page == "Home":

    st.title("Enterprise AI Customer Churn Prediction Platform")
    st.divider()

    col1, col2, col3 = st.columns([3, 2, 3])
    with col2:
        st.image(
            "https://cdn-images-1.medium.com/max/1200/0*mInebiTUMkfPf0yk.jpg",
            use_container_width = True
        )

    st.markdown("""
### Welcome

**The goal of this project is to demonstrate an end-to-end data science workflow:**

Merging proven Project Management methodologies with modern, full-stack Data Science, ML, and AI Engineering
*to build an enterprise-level customer churn prediction platform that can be used by business executives
to make data-driven decisions and improve customer retention.*
""")

    st.divider()
    st.subheader("Technology Stack")

    col1, col2 = st.columns(2, gap = "large")

    with col1:
        st.info("""
### 💻 Technical Stack

✔ SQL Data Engineering

✔ Advanced Analytics

✔ Statistical Testing

✔ Machine Learning

✔ Enterprise AI Copilot

✔ Agentic AI

✔ Enterprise MLOps
""")

    with col2:
        st.success("""
### 📋 Project Management Stack

✔ Agile Project Management

✔ Kanban

✔ Epics & Stories

✔ Jira & Confluence

✔ CRISP-DM

✔ KPI Trees
""")

    st.divider()

    col1, col2, col3 = st.columns(3)
    col1.metric("Customers", len(gold_df))
    col2.metric("Features",  gold_df.shape[1])
    col3.metric("Production Model", metadata["algorithm"])


# ==========================================================
# EXECUTIVE DASHBOARD
# ==========================================================

elif page == "Executive Dashboard":

    st.title("Executive Dashboard")
    st.markdown("High-level business metrics generated from the production dataset.")

    # ── KPI Metrics ───────────────────────────────────────
    col1, col2, col3, col4 = st.columns(4)

    total_revenue  = gold_df["lifetime_spend"].sum()
    avg_customer   = gold_df["lifetime_spend"].mean()
    high_value     = prediction_df["predicted_high_value"].sum()
    total_customers = len(gold_df)

    col1.metric("Customers",           f"{total_customers:,}")
    col2.metric("Revenue",             f"${total_revenue:,.0f}")
    col3.metric("Avg Customer Value",  f"${avg_customer:,.2f}")
    col4.metric("Predicted High Value", f"{high_value:,}")

    # ── Revenue Distribution ───────────────────────────────
    st.markdown("---")
    st.subheader("Revenue Distribution")

    fig = px.histogram(
        gold_df, x = "lifetime_spend", nbins = 40,
        labels = {"lifetime_spend": "Customer Lifetime Spend ($)",
                  "count": "Number of Customers"},
        title = "Customer Monetary Value Distribution"
    )
    st.plotly_chart(fig, use_container_width = True)

    # ── Customer Segmentation ──────────────────────────────
    st.markdown("---")
    st.subheader("Customer Segmentation")

    fig = px.scatter_3d(
    gold_df,
    x = "recency_days",
    y = "lifetime_spend",
    z = 'avg_days_between_purchases',
    labels = {'recency_days': 'Recency (Days)', 'lifetime_spend': 'Monetary Value ($)', 'avg_days_between_purchases': 'Frequency (Avg Days Between Purchase)'},
    color = "lifetime_spend",
    hover_data = [
        "customerID",
        "payment_method_diversity",
        "lifetime_spend",
        "avg_days_between_purchases",
    ],
    title = "3D RFM Customer View",
)

    fig.update_layout(width = 500, height = 700)

    st.plotly_chart(fig, use_container_width = True)

    # ── Prediction Breakdown ───────────────────────────────
    st.markdown("---")
    st.subheader("Prediction Breakdown")

    prediction_counts = (
        prediction_df["predicted_high_value"]
        .value_counts().reset_index()
    )
    prediction_counts.columns = ["Prediction", "Count"]
    prediction_counts["Prediction"] = prediction_counts["Prediction"].map(
        {0: "Standard", 1: "High Value"}
    )

    fig = px.pie(
        prediction_counts,
        names = "Prediction", values = "Count",
        title = "Customer Prediction Distribution"
    )
    st.plotly_chart(fig, use_container_width = True)

    # ── Prediction Confidence ──────────────────────────────
    if "probability" in prediction_df.columns:
        st.markdown("---")
        st.subheader("Prediction Confidence")

        fig = px.histogram(
            prediction_df, x = "probability", nbins = 30,
            title = "Predicted Probability Distribution"
        )
        st.plotly_chart(fig, use_container_width = True)

    # ── Executive Summary ──────────────────────────────────
    st.markdown("---")
    st.subheader("Executive Summary")
    st.success("""
• Production model successfully loaded.

• Predictions generated for all customers.

• Dashboard connected to production artifacts.

• Ready for AI-assisted business recommendations.
""")


# ==========================================================
# CUSTOMER PREDICTION
# ==========================================================

elif page == "Predict On Your Own!":

    st.title("Customer Prediction")
    st.markdown("""
Upload a customer dataset to generate production predictions
using the deployed Machine Learning model.
""")

    uploaded_file = st.file_uploader("Upload CSV", type = ["csv"])

    if uploaded_file is not None:

        prediction_input = pd.read_csv(uploaded_file)

        st.subheader("Preview")
        st.dataframe(prediction_input.head())

        if st.button("Generate Predictions"):

            prediction_df_new = prediction_input.copy()

            feature_df = prediction_df_new.drop(
                columns = ["customer_id"], errors = "ignore"
            )

            predictions = model.predict(feature_df)
            prediction_df_new["prediction"] = predictions

            if hasattr(model, "predict_proba"):
                probabilities = model.predict_proba(feature_df)
                prediction_df_new["probability"] = probabilities[:, 1]

            # Persist to session state so other pages can access it
            st.session_state["prediction_df"] = prediction_df_new

            st.success("Predictions completed successfully.")
            st.dataframe(prediction_df_new.head())

            st.download_button(
                label = "Download Predictions",
                data = prediction_df_new.to_csv(index = False),
                file_name = "customer_predictions.csv",
                mime = "text/csv"
            )


# ==========================================================
# ENTERPRISE AI COPILOT
# ==========================================================

elif page == "Enterprise AI Copilot":

    st.title("Enterprise AI Copilot")
    st.markdown("""
Ask a business question and the Enterprise AI Workflow will coordinate
four specialist agents — **Analytics, Machine Learning, Strategy,** and **Executive** —
to deliver a full decision intelligence report based on this project's production dataset,
findings, and model predictions.
""")

    # Safely retrieve uploaded "prediction_df" if available,
    # otherwise fall back to the production predictions
    session_preds  = st.session_state.get("prediction_df", pd.DataFrame())
    active_preds   = session_preds if not session_preds.empty else prediction_df

    question = st.text_area("Business Question")

    if st.button("Run Enterprise AI Workflow"):

        if not question.strip():
            st.warning("Please enter a business question before running.")
        else:
            dataset_summary    = gold_df.describe().to_string()
            prediction_summary = active_preds.head(20).to_string()

            with st.spinner("Running 4-agent enterprise workflow…"):
                outputs = run_enterprise_workflow(
                    user_request = question,
                    dataset_summary = dataset_summary,
                    prediction_summary = prediction_summary
                )

            st.success("Workflow completed.")

            with st.expander("📊 Analytics Agent", expanded = False):
                st.markdown(outputs["analytics"])

            with st.expander("🤖 Machine Learning Agent", expanded = False):
                st.markdown(outputs["ml"])

            with st.expander("📋 Strategy Agent", expanded = False):
                st.markdown(outputs["strategy"])

            st.subheader("📝 Executive Report")
            st.markdown(outputs["executive"])

            st.download_button(
                label = "Download Executive Report",
                data = outputs["executive"],
                file_name = "executive_report.txt",
                mime = "text/plain"
            )


# ==========================================================
# MODEL INSIGHTS
# ==========================================================

elif page == "Model Insights":

    st.title("Model Insights")
    st.markdown("""
                Performance of the deployed Machine Learning model.
                
                Did it accurately predict *high-value* customers for the business? 
                How confident was the model in its predictions?

                """)

    st.metric("Model",     metadata["model_name"])
    st.metric("Version",   metadata["version"])
    st.metric("Algorithm", metadata["algorithm"])

    st.markdown("---")
    st.subheader("Prediction Sample")

    session_preds = st.session_state.get("prediction_df", pd.DataFrame())
    active_preds  = session_preds if not session_preds.empty else prediction_df
    st.dataframe(active_preds.head(20))

    st.markdown("---")
    st.subheader("Feature Importance")

    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.image(
            "/Users/alijazibrizvi/Documents/Data Analytics/Project Management - Enterprise AI Customer Churn Prediction Platform/feature-importance-xgboost.png",
            use_container_width = True #, width = 600, height = 400
        )

    st.markdown("---")
    st.subheader("Model Performance")

    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.image(
            "/Users/alijazibrizvi/Documents/Data Analytics/Project Management - Enterprise AI Customer Churn Prediction Platform/evaluation-ml-models-03_04.png",
            use_container_width = True
        )


# ==========================================================
# PROJECT DOCUMENTATION
# ==========================================================

elif page == "Project Documentation":

    st.title("Project Documentation")

    st.markdown("""
### Enterprise Customer Churn Predictor

---

#### Project Workflow

| Stage | Description |
|---|---|
| 1 | SQL Data Engineering |
| 2 | Advanced Analytics |
| 3 | Statistical Testing |
| 4 | Machine Learning |
| 5 | Explainable AI |
| 6 | Enterprise AI Copilot |
| 7 | Agentic AI |
| 8 | Enterprise MLOps |
| 9 | Executive Decision Support |

---

#### Project Management

✔ Agile &nbsp;✔ Kanban &nbsp;✔ Jira &nbsp;✔ Confluence &nbsp;✔ CRISP-DM &nbsp;✔ KPI Trees

---

#### Technology Stack

✔ Python &nbsp;✔ SQL &nbsp;✔ Streamlit &nbsp;✔ Scikit-learn &nbsp;✔ XGBoost &nbsp;✔ OpenAI API &nbsp;✔ Plotly &nbsp;✔ GitHub
""")


# ==========================================================
# Footer (renders on every page)
# ==========================================================

st.markdown("---")
st.caption(
    "Enterprise Customer Churn Prediction Platform | "
    "Version 1.0 | "
    "Built by Ali Jazib Rizvi"
)