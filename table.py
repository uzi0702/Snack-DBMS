from sqlalchemy import Integer, String
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import mapped_column

class Base(DeclarativeBase):
    pass

class SnackTable(Base):
    __tablename__ = "snack_table"
    id = mapped_column(Integer, primary_key=True, autoincrement=True)
    name = mapped_column(String(50), primary_key=False)
    owner = mapped_column(String(50), nullable=False)
    eatable = mapped_column(String(20), nullable=False)
    image = mapped_column(String(50), nullable=True)

    def __repr__(self) -> str:
        return f"snack_table(name={self.name}, owner={self.owner}, eatable={self.eatable}, image={self.image} )"

