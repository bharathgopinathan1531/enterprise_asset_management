from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.models.allocation_model import Allocation
from app.schemas.allocation_schema import (
    AllocationCreate,
    AllocationResponse
)

router = APIRouter(
    prefix="/allocations",
    tags=["Allocations"]
)


@router.post("/", response_model=AllocationResponse)
def create_allocation(
    allocation: AllocationCreate,
    db: Session = Depends(get_db)
):

    new_allocation = Allocation(
        employee_id=allocation.employee_id,
        asset_id=allocation.asset_id,
        allocated_date=allocation.allocated_date,
        return_date=allocation.return_date
    )

    db.add(new_allocation)
    db.commit()
    db.refresh(new_allocation)

    return new_allocation


@router.get("/", response_model=list[AllocationResponse])
def get_allocations(db: Session = Depends(get_db)):

    allocations = db.query(Allocation).all()

    return allocations