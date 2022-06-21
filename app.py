#!/usr/bin/env python3
""" CDK Configuration for the nasa-analytics stack."""

from aws_cdk import App, Stack, Tags, aws_iam,DefaultStackSynthesizer
from constructs import Construct
from cluster.construct import ClusterConstruct

app = App()


class AnalyticsStack(Stack):
    """CDK stack for the nasa-analytics stack."""

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        """."""
        super().__init__(scope, construct_id, **kwargs)

analytics_stack = AnalyticsStack( app, "analytics-stack",synthesizer=DefaultStackSynthesizer(qualifier="analytics"))

cluster = ClusterConstruct(analytics_stack, "cluster")

for key, value in {
    "Project": "NASA Analytics",
    "Stack": "dev-stack",
    "Client": "nasa-impact",
    "Owner": "ds",
}.items():
    if value:
        Tags.of(app).add(key=key, value=value)

app.synth()
