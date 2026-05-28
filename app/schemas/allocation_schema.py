from pydantic import BaseModel


class AllocationCreate(BaseModel):
    employee_id: int
    asset_id: int
    allocated_date: str
    return_date: str | None = None


class AllocationResponse(AllocationCreate):
    id: int

    class Config:
        from_attributes = True