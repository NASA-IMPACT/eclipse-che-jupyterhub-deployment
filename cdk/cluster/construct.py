"""CDK Construct for a EKS based Kubernetes cluster."""
import os

from aws_cdk import (
    CfnOutput,
    Duration,
    Stack,
    aws_eks,
    aws_ec2,
    aws_iam,
)
from constructs import Construct


class ClusterConstruct(Construct):
    """CDK Construct for a EKS based Kubernetes cluster."""

    def __init__(
            self,
            scope: Construct,
            construct_id: str,
            code_dir: str = "./",
            **kwargs,
    ) -> None:
        """."""
        super().__init__(scope, construct_id)

        # TODO config
        stack = Stack.of(self)

        vpc = aws_ec2.Vpc(
            self,
            "vpc-test"
        )

        account_id = stack.account
        role = aws_iam.Role(self, "analytics-cluster-role",
                            assumed_by=aws_iam.AccountPrincipal(account_id),
                            description="Cluster admin role for analytics cluster")

        cluster = aws_eks.Cluster(self, "analytics-cluster",
                                  version=aws_eks.KubernetesVersion.V1_21,
                                  vpc=vpc,
                                  vpc_subnets=[
                                      aws_ec2.SubnetSelection(subnet_type=aws_ec2.SubnetType.PRIVATE_WITH_NAT)],
                                  masters_role=role,
                                  )

