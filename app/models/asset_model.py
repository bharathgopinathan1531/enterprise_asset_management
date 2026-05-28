from sqlalchemy import Column, Integer, String
from app.database.database import Base


class Asset(Base):
    __tablename__ = "assets"

    id = Column(Integer, primary_key=True, index=True)
    asset_name = Column(String, nullable=False)
    asset_type = Column(String, nullable=False)
    serial_number = Column(String, unique=True, nullable=False)
    status = Column(String, default="available")
    assigned_to = Column(String, nullable=True)