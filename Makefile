.PHONY: help install dev test lint format clean build publish

help:
	@echo "Lumen Python SDK - Makefile Commands"
	@echo ""
	@echo "  make install    Install package dependencies"
	@echo "  make dev        Install package in development mode with dev dependencies"
	@echo "  make test       Run tests with pytest"
	@echo "  make lint       Run linters (ruff, mypy)"
	@echo "  make format     Format code with black"
	@echo "  make clean      Clean build artifacts"
	@echo "  make build      Build package for distribution"
	@echo "  make publish    Publish package to PyPI"

install:
	pip install -e .

dev:
	pip install -e ".[dev,flask,fastapi,django]"

test:
	pytest

test-cov:
	pytest --cov=lumen --cov-report=html --cov-report=term

lint:
	ruff check lumen tests examples
	mypy lumen

format:
	black lumen tests examples
	ruff check --fix lumen tests examples

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: clean
	pip install build
	python -m build

publish: build
	pip install twine
	python -m twine upload dist/*

