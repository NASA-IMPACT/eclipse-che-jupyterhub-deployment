import pydantic


class Settings(pydantic.BaseSettings):
    project_tag: str = "NASA Analytics"
    stack_tag: str = "dev-stack"
    client_tag: str = "nasa-impact"
    owner_tag: str = "ds"
    qualifier: str = 'analysis'
    auth_client_name: str = "not_random_auth_client_name"
    auth_client_secret: str = "not_random_auth_secret"
    cluster_region: str = "us-west-2"

    class Config:
        env_file = '.env'
