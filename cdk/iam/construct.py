"""CDK Construct for IAM roles to support Eclipse Che."""

from aws_cdk import (
    Stack,
    aws_iam,
    aws_secretsmanager,
)
from constructs import Construct


class IamConstruct(Construct):
    """CDK Construct for IAM roles to support Eclipse Che."""

    def __init__(
            self,
            scope: Construct,
            construct_id: str,
            qualifier: str,
            code_dir: str = "./",
            **kwargs,
    ) -> None:
        """."""
        super().__init__(scope, construct_id)

        # TODO config
        stack = Stack.of(self)

        user = aws_iam.User(self, f"certmanager-user-{qualifier}",
                            user_name=f"certmanager-user-{qualifier}")

        access_key = aws_iam.AccessKey(self, f"certmanager-accesskey-{qualifier}",
                                       user=user)

        secret_id_value = aws_secretsmanager.SecretStringValueBeta1.from_token(access_key.access_key_id)
        secret_id = aws_secretsmanager.Secret(self, f"certmanager-accesskeyid-{qualifier}",
                                              secret_name=f"certmanager-accesskeyid-{qualifier}",
                                              secret_string_beta1=secret_id_value)

        secret_value = aws_secretsmanager.SecretStringValueBeta1.from_token(access_key.secret_access_key.to_string())
        secret = aws_secretsmanager.Secret(self, f"certmanager-accesskey-secret-{qualifier}",
                                           secret_name=f"certmanager-accesskey-secret-{qualifier}",
                                           secret_string_beta1=secret_value
                                           )
