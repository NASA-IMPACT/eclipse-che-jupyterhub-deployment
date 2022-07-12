import pydantic


class Settings(pydantic.BaseSettings):
    project_tag: str
    stack_tag: str
    client_tag: str
    owner_tag: str
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
