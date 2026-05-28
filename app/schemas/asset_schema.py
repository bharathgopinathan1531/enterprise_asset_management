from pydantic import BaseModel


class AssetCreate(BaseModel):
    asset_name: str
    asset_type: str
    serial_number: str
    status: str = "available"
    assigned_to: str | None = None


class AssetResponse(BaseModel):
    id: int
    asset_name: str
    asset_type: str
    serial_number: str
    status: str
    assigned_to: str | None

    class Config:
        from_attributes = True