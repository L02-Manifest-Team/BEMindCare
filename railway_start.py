#!/usr/bin/env python
"""
Railway startup script - handles PORT environment variable
"""
import os
import sys

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    print(f">>> [RAILWAY] Starting server on port {port}")
    
    # Import uvicorn after port is determined
    import uvicorn
    
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=port,
        log_level="info"
    )
