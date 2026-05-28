from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.models.asset_model import Asset
from app.schemas.asset_schema import AssetCreate, AssetResponse

router = APIRouter(prefix="/assets", tags=["Assets"])


# Create Asset
@router.post("/", response_model=AssetResponse)
def create_asset(asset: AssetCreate, db: Session = Depends(get_db)):

    new_asset = Asset(
        asset_name=asset.asset_name,
        asset_type=asset.asset_type,
        serial_number=asset.serial_number,
        status=asset.status,
        assigned_to=asset.assigned_to
    )

    db.add(new_asset)
    db.commit()
    db.refresh(new_asset)

    return new_asset


# Get All Assets
@router.get("/", response_model=list[AssetResponse])
def get_assets(db: Session = Depends(get_db)):

    assets = db.query(Asset).all()

    return assets