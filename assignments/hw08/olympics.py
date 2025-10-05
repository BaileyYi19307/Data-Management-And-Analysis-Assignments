import configparser
from operator import itemgetter

import sqlalchemy
from sqlalchemy import create_engine,select

# columns and their types, including fk relationships
from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

# declarative base, session, and datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# configuring your database connection
config = configparser.ConfigParser()
config.read('config.ini')
u, pw, host, db = itemgetter('username', 'password', 'host', 'database')(config['db'])
dsn = f'postgresql://{u}:{pw}@{host}/{db}'
print(f'using dsn: {dsn}')

# SQLAlchemy engine, base class and session setup
engine = create_engine(dsn, echo=True)
Base = declarative_base()
Session = sessionmaker(engine)
session = Session()

# TODO: Write classes and code here
class AthleteEvent(Base):
    __tablename__ = 'athlete_event'

    athlete_event_id = Column(Integer, primary_key=True)
    id = Column(Integer)
    name = Column(String)
    sex = Column(String(1))
    age = Column(Integer)
    height = Column(Float) 
    weight = Column(Float)
    team = Column(String)
    noc = Column(String(10),ForeignKey("noc_region.noc"))
    games = Column(String)
    year = Column(Integer)
    season = Column(String(10))
    city = Column(String)
    sport = Column(String)
    event = Column(String)
    medal = Column(String)

    noc_region = relationship("NOCRegion", back_populates="athlete_events")
    def __repr__(self):
        return f"name='{self.name}', event='{self.event}', medal='{self.medal}'"

    def __str__(self):
        return f"{self.name} ({self.noc}) - {self.season} {self.year} | {self.event} | {self.medal}"

class NOCRegion(Base):
    __tablename__ = 'noc_region'

    noc = Column(String(10), primary_key=True)
    region = Column(String)
    note = Column(String)
    athlete_events = relationship("AthleteEvent", back_populates="noc_region")
    def __repr__(self):
        return f"noc='{self.noc}', region='{self.region}'"

    def __str__(self):
        return f"{self.region} ({self.noc})"


new_event=AthleteEvent(name='Yuto Horigome',
    age=21,
    team='Japan',
    medal='Gold',
    year=2020,
    season='Summer',
    city='Tokyo',
    noc='JPN',
    sport='Skateboarding',
    event='Skateboarding, Street, Men')

session.add(new_event)
session.commit()

query=select(AthleteEvent).where(AthleteEvent.noc=='JPN', AthleteEvent.year >= 2016, AthleteEvent.medal == 'Gold')
results=session.scalars(query)

for athlete in results:
        print(f"{athlete.name}, {athlete.noc_region.region}, {athlete.event}, {athlete.year}, {athlete.season}")
  
session.close()

