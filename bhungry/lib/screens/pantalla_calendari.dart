import 'package:bhungry/models/events.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PantallaCalendar extends StatefulWidget {
  const PantallaCalendar({Key? key}) : super(key: key);

  @override
  State<PantallaCalendar> createState() => _PantallaCalendarState();
}

class _PantallaCalendarState extends State<PantallaCalendar> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateFormat? dateFormat;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = new DateFormat.MMMMd('es');

    setState(() {
      _isLoading = true;
    });

    selectedEvents[DateTime.utc(2022, 4, 20)] = [
      Event(titulo: "Reserva en Txacoli", hora: "13:30")
    ];
    selectedEvents[DateTime.utc(2022, 4, 20)]!
        .add(Event(titulo: "Reserva en Can Rectoret", hora: "21:00"));

    setState(() {
      _isLoading = false;
    });
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                children: [
                  TableCalendar(
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextFormatter: (date, locale) =>
                          DateFormat.E('es').format(date),
                    ),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    eventLoader: _getEventsFromDay,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                          color: Colors.yellow, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                          color: Colors.amber, shape: BoxShape.circle),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(left: 15),
                      decoration: const BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd')
                                                .format(selectedDay) ==
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now())
                                        ? "Hoy"
                                        : "Dia " +
                                            dateFormat!.format(selectedDay),
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              selectedEvents[selectedDay] == null
                                  ? Center(
                                      child: Text(
                                        "Sin reservas",
                                        style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                    )
                                  : Container(),
                              ..._getEventsFromDay(selectedDay).map(
                                  (Event event) => event.titulo == "" ||
                                          event.titulo == null
                                      ? Center(child: Text("Sin reservas"))
                                      : Container(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(children: [
                                            Icon(CupertinoIcons.clock_solid,
                                                color: Colors.white, size: 30),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(event.titulo,
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Hora de la reserva: " +
                                                          event.hora,
                                                      style: GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white,
                                                      )))
                                                ],
                                              ),
                                            )
                                          ]),
                                        )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
      ),
    );
  }
}
