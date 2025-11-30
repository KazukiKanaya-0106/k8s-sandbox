import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse


def main() -> FastAPI:
    app = FastAPI()

    @app.get("/")
    def read_root():
        return JSONResponse(
            status_code=200,
            content={"Hello": "World"}
        )
    
    @app.get("/health")
    def health_check():
        return JSONResponse(
            status_code=200,
            content={"status": "ok"}
        )
    
    @app.get("/value")
    def read_secret():
        return JSONResponse(
            status_code=200,
            content={
                "stage": os.getenv("STAGE", "not set"),
                "secret": os.getenv("SECRET_VALUE", "not set")
            }
        )

    return app

app = main()