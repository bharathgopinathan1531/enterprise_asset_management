from pydantic import BaseModel

class MaintenanceCreate(BaseModel):
    asset_id: int
    issue: str

class MaintenanceResponse(MaintenanceCreate):
    id: int
    status: str

    class Config:
        orm_mode = True