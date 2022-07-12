import pydantic


class Settings(pydantic.BaseSettings):
    project_tag: str = "NASA Analytics"
    stack_tag: str = "dev-stack"
    client_tag: str = "nasa-impact"
    owner_tag: str = "ds"
    qualifier: str
    idp_url: str
    idp_user_claim: str
    auth_client_name: str
    auth_secret: str
    aws_access_key_id: str
    aws_secret_access_key: str
    cluster_region: str

    class Config:
        env_file = '.env'
