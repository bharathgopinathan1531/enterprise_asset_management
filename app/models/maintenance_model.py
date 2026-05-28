from sqlalchemy import Column, Integer, String, ForeignKey
from app.database.database import Base

class Maintenance(Base):
    __tablename__ = "maintenance"

    id = Column(Integer, primary_key=True, index=True)
    asset_id = Column(Integer, ForeignKey("assets.id"))
    issue = Column(String, nullable=False)
    status = Column(String, default="Pending")