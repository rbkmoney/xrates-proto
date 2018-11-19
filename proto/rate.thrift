namespace java com.rbkmoney.xrates.rate
namespace erlang rate

include "base.thrift"

typedef i64 EventID
typedef base.Rational ExchangeRate

/** ISO 4217 */
typedef string CurrencySymbolicCode

typedef string SourceID

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

exception NoLastEvent {}

union ExchangeRateStatus {
    1: ExchangeRatePending   pending
    2: ExchangeRateCompleted completed
}

struct ExchangeRatePending {}
struct ExchangeRateCompleted {
    1: required list<Quote> qoutes
}

struct Currency {
    1: required CurrencySymbolicCode symbolic_code
    2: required i16 exponent
}

union Change {
    1: ExchangeRateData   created
    2: ExchangeRateStatus status_changed
}

struct ExchangeRateData {
    1: required base.TimestampInterval interval
    2: required SourceID source
}

struct Quote {
    1: required Currency source
    2: required Currency target
    3: required ExchangeRate exchange_rate
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