from sqlalchemy import Column, Integer, String, ForeignKey
from app.database.database import Base


class Allocation(Base):
    __tablename__ = "allocations"

    id = Column(Integer, primary_key=True, index=True)

    employee_id = Column(Integer, ForeignKey("employees.id"))
    asset_id = Column(Integer, ForeignKey("assets.id"))

    allocated_date = Column(String)
    return_date = Column(String, nullable=True)