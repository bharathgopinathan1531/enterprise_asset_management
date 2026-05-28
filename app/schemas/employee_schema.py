from pydantic import BaseModel


class EmployeeCreate(BaseModel):
    name: str
    email: str
    department: str
    designation: str


class EmployeeResponse(EmployeeCreate):
    id: int

    class Config:
        from_attributes = True