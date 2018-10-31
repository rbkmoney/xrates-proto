namespace java com.rbkmoney.xrates.rate
namespace erlang rate

include "base.thrift"

typedef i64 EventID
typedef base.Rational RateValue

/** ISO 4217 */
typedef string CurrencySymbolicCode

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

exception NoLastEvent {}

struct Currency {
    1: required CurrencySymbolicCode symbolic_code
    2: required i16 exponent
}

union Change {
    1: ExchangeRateData exchange_rate_data
}

struct ExchangeRateData {
    1: required base.Date date
    2: required Currency source_currency
    3: required Source source
    4: list<Rate> rates
}

struct Rate {
    1: required Currency currency
    2: required RateValue rate_value
}

enum Source {
    cbr
}

struct Event {
    1: required list<Change> changes
}

struct SinkEvent {
    1: required EventID   id
    2: required base.Timestamp created_at
    3: required string    source
    4: required Event     payload
}

service EventSink {

    list<SinkEvent> GetEvents (1: EventRange range)
        throws ()

    EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}