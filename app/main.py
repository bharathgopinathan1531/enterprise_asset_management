from fastapi import FastAPI

from app.database.database import engine, Base
from app.models.user_model import User
from app.models.employee_model import Employee
from app.models.allocation_model import Allocation
from app.routes.user_route import router
from app.routes.asset_route import router as asset_router
from app.routes.employee_route import router as employee_router
from app.routes.allocation_route import router as allocation_router
from app.routes.maintenance_route import router as maintenance_router
app = FastAPI()

Base.metadata.create_all(bind=engine)

app.include_router(router)
app.include_router(asset_router)
app.include_router(employee_router)
app.include_router(allocation_router)
app.include_router(maintenance_router)


@app.get("/")
def home():
    return {"message": "Enterprise Asset Management System Running"}