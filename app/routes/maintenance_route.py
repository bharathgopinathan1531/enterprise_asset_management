from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import SessionLocal
from app.models.maintenance_model import Maintenance
from app.schemas.maintenance_schema import (
    MaintenanceCreate,
    MaintenanceResponse
)

router = APIRouter(
    prefix="/maintenance",
    tags=["Maintenance"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MaintenanceResponse)
def create_maintenance(
    maintenance: MaintenanceCreate,
    db: Session = Depends(get_db)
):
    new_maintenance = Maintenance(**maintenance.dict())

    db.add(new_maintenance)
    db.commit()
    db.refresh(new_maintenance)

    return new_maintenance

@router.get("/", response_model=list[MaintenanceResponse])
def get_maintenance(db: Session = Depends(get_db)):
    return db.query(Maintenance).all()