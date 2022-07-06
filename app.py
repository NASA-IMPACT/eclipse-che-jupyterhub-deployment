#!/usr/bin/env python3
""" CDK Configuration for the nasa-analytics stack."""

import os
from aws_cdk import App, Stack, Tags, DefaultStackSynthesizer
from constructs import Construct
from cdk.cluster.construct import ClusterConstruct
from cdk.iam.construct import IamConstruct

app = App()


class AnalyticsStack(Stack):
    """CDK stack for the nasa-analytics stack."""

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        """."""
        super().__init__(scope, construct_id, **kwargs)


qualifier = os.getenv('QUALIFIER')

analytics_stack = AnalyticsStack(app, f"{qualifier}-analytics-stack", synthesizer=DefaultStackSynthesizer(qualifier=qualifier))

cluster = ClusterConstruct(analytics_stack, "cluster", qualifier=qualifier)
iam = IamConstruct(analytics_stack, "iam", qualifier=qualifier)

for key, value in {
    "Project": "NASA Analytics",
    "Stack": "dev-stack",
    "Client": "nasa-impact",
    "Owner": "ds",
}.items():
    if value:
        Tags.of(app).add(key=key, value=value)

app.synth()
