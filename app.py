#!/usr/bin/env python3
""" CDK Configuration for the nasa-analytics stack."""

import os
from aws_cdk import App, Stack, Tags, DefaultStackSynthesizer
from constructs import Construct
from cdk.cluster.construct import ClusterConstruct
from cdk.iam.construct import IamConstruct
from config import Settings

config = Settings()
app = App()

cdk_tags = {
    "Project": config.project_tag,
    "Stack": config.stack_tag,
    "Client": config.client_tag,
    "Owner": config.owner_tag,
}


class AnalyticsStack(Stack):
    """CDK stack for the nasa-analytics stack."""

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        """."""
        super().__init__(scope, construct_id, **kwargs)


analytics_stack = AnalyticsStack(
    app,
    f"analytics-stack-{config.qualifier}",
    synthesizer=DefaultStackSynthesizer(qualifier=config.qualifier)
)

cluster = ClusterConstruct(analytics_stack, "cluster", qualifier=config.qualifier, cdk_tags=cdk_tags)
iam = IamConstruct(analytics_stack, "iam", qualifier=config.qualifier)

for key, value in cdk_tags.items():
    if value:
        Tags.of(app).add(key=key, value=value)

app.synth()
