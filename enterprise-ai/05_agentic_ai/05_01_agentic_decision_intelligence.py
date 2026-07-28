# =========================================================
# AGENTIC DECISION INTELLIGENCE
# =========================================================
#
# Notebook:
# 05_01_agentic_decision_intelligence.py
#
# Purpose
# -------
# Build a simple Enterprise Multi-Agent AI system.
#
# Unlike a traditional chatbot,
# Agentic AI divides complex problems into
# specialized responsibilities.
#
# Each AI Agent performs a focused task before
# handing results to the next agent.
#
# =========================================================



# =========================================================
# 1. IMPORT LIBRARIES
# =========================================================

import os
import joblib
import pandas as pd

from dotenv import load_dotenv, find_dotenv
from openai import OpenAI



# =========================================================
# 2. LOAD ENVIRONMENT VARIABLES
# =========================================================

load_dotenv(find_dotenv())

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY")
)



# =========================================================
# 3. LOAD PRODUCTION ASSETS
# =========================================================
#
# Reuse the production artifacts created in the
# Machine Learning stage.
#
# Agentic systems should consume production-ready
# outputs rather than retraining models.
#
# =========================================================

gold_df = pd.read_csv(
    "../data/gold_ml_customer_features.csv"
)

prediction_df = pd.read_csv(
    "../outputs/customer_predictions_explained.csv"
)

model = joblib.load(
    "../models/xgboost_model.pkl"
)



# =========================================================
# 4. WHAT IS AGENTIC AI?
# =========================================================
#
# Traditional LLM:
#
# User
#   ↓
# One AI
#   ↓
# Response
#
#
# Agentic AI:
#
# User
#   ↓
# Planner
#   ↓
# Specialist Agents
#   ↓
# Final Response
#
# Each Agent has one responsibility.
#
# This improves organization,
# modularity,
# and scalability.
#
# =========================================================



# =========================================================
# 5. AGENT DEFINITIONS
# =========================================================
#
# Instead of one enormous prompt,
# each Agent receives
# a dedicated professional role.
#
# =========================================================

AGENTS = {

    "analytics": """

You are a Senior Retail Analytics Specialist.

Analyze KPIs.

Identify trends.

Summarize customer behaviour.

Only discuss descriptive analytics.

""",


    "machine_learning": """

You are a Senior Machine Learning Scientist.

Interpret model outputs.

Explain predictions.

Discuss feature importance.

Explain uncertainty.

""",


    "strategy": """

You are a Retail Strategy Consultant.

Convert analytical findings into
business recommendations.

Focus on practical actions.

""",


    "executive": """

You are a Chief Decision Officer.

Combine every agent's findings.

Write an executive report.

Communicate professionally.

"""

}



print("Available Enterprise Agents:\n")

for name in AGENTS:

    print(f"• {name}")

# =========================================================
# 5A. ORCHESTRATOR AGENT
# =========================================================
#
# Purpose
# -------
# The Orchestrator coordinates the work of the
# specialist AI Agents.
#
# Rather than solving the business problem itself,
# it decides:
#
# • Which specialist agents should participate
# • The order in which they should execute
# • What information should be shared
# • When the workflow is complete
#
# This mirrors how many enterprise multi-agent
# frameworks coordinate specialized AI systems.
#
# =========================================================

ORCHESTRATOR = """

You are the Enterprise AI Workflow Orchestrator.

Your responsibilities are:

• Understand the user's objective.

• Determine which specialist AI agents
should contribute.

• Coordinate the flow of information
between agents.

• Combine intermediate findings into
one coherent workflow.

• Deliver the completed analysis to
the Executive Agent.

Never perform specialist analysis yourself.

Instead, delegate work to the appropriate
specialist agents.

"""

# =========================================================
# 6. GENERIC AGENT FUNCTION
# =========================================================
#
# Every Agent shares the same architecture.
#
# The only thing that changes
# is its assigned System Prompt.
#
# =========================================================

MODEL_NAME = "gpt-4.1-mini"

TEMPERATURE = 0.2


def run_agent(

    agent_name,

    user_request,

    model=MODEL_NAME,

    temperature=TEMPERATURE

):

    messages = [

        {

            "role": "system",

            "content": AGENTS[agent_name]

        },

        {

            "role": "user",

            "content": user_request

        }

    ]

    response = client.chat.completions.create(

        model=model,

        messages=messages,

        temperature=temperature

    )

    return response.choices[0].message.content



# =========================================================
# 7. EXAMPLE AGENT TASK
# =========================================================
#
# Each specialist receives
# the SAME business request,
# but responds from
# a different professional perspective.
#
# =========================================================

business_question = """

Customer churn has increased.

What should management know?

"""

analytics_report = run_agent(

    "analytics",

    business_question

)

ml_report = run_agent(

    "machine_learning",

    business_question

)

strategy_report = run_agent(

    "strategy",

    business_question

)



print("\nAnalytics Agent\n")

print(analytics_report)


print("\nMachine Learning Agent\n")

print(ml_report)


print("\nStrategy Agent\n")

print(strategy_report)



# =========================================================
# 8. AGENT COLLABORATION
# =========================================================
#
# The Executive Agent combines
# outputs from every specialist.
#
# This mimics how real enterprise teams
# share expertise before
# leadership makes decisions.
#
# =========================================================

# =========================================================
# 8. ORCHESTRATED AGENT WORKFLOW
# =========================================================
#
# In a production Agentic AI system,
# the Orchestrator manages the workflow
# between specialist agents.
#
# For simplicity, this notebook performs the
# orchestration sequentially while demonstrating
# the overall architecture.
#
# =========================================================

workflow_plan = """

User Request
      ↓
Orchestrator
      ↓
Analytics Agent
      ↓
Machine Learning Agent
      ↓
Strategy Agent
      ↓
Executive Agent

"""

print(workflow_plan)

combined_context = f"""
Analytics Findings

{analytics_report}

Machine Learning Findings

{ml_report}

Strategic Recommendations

{strategy_report}
"""


# =========================================================
# NOTEBOOK SUMMARY
# =========================================================
#
# Completed:
#
# ✓ Specialized AI Agents
# ✓ Modular Prompt Design
# ✓ Agent Collaboration
# ✓ Executive Report Generation
#
# Next Notebook:
#
# 05_02_enterprise_ai_workflow.py
#
# where these agents become part of
# one orchestrated business workflow.
#
# =========================================================