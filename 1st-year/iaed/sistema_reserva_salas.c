/**
 * File        : proj1.c
 * Author      : Cristiano Clemente (ist192440)
 * Date        : 30/03/2019
 * Language    : C
 * Course      : Introduction to Algorithms and Data Structures
 * Description : This script works as a room booking tool.
 *               It allows for creating and manipulating events associated to different rooms.
 */

#include <stdio.h>		/* Functions used: fgets, getchar, printf.*/
#include <string.h>		/* Functions used: strcmp */

/* Maximum # of events per room = 100 and # of rooms = 10 therefore max total # of events = 1000 */
#define MAXEVENTS 1000
/* Maximum amount of event attendees (leader+participants) */
#define MAXPPL 4
/* Maximum string lenght = maximum description/participant name lenght(63) + '\0'(1) */
#define MAXSTR 64
/* Maximum line lenght = 5*63(description+4participants)+8(date)+4(start time)+4(duration)+2(room)+8*(':')+1*('\0') = 342 */
#define MAXLINE 342
#define DELIMITER ':'
#define TRUE 1                    /* Equivalent to boolean True. */
#define FALSE 0                   /* Equivalent to boolean False. */

/**
 * Structure that represents an event.
 */
typedef struct {
  char descrip[MAXSTR];           /* str: event_description (UNIQUE!) */
  int day;                        /* int : 1 <= day <= 31 */
  int month;                      /* int: 1 <= month <= 12 */
  int year;                       /* int: 2019 <= year */
  int hh;                         /* int: 00 <= start_time_hours <= 23 */
  int mm;                         /* int: 00 <= start_time_minutes <= 59 */
  int dur;						            /* int: 1 <= event_duration(IN MINUTES) <= 1440 */
  int room;                       /* int: 1 <= room_number <= 10 */
  char p[MAXPPL][MAXSTR];		      /* array of strs: leader (REQUIRED!) + 1st_participant (REQUIRED!) + 2nd/3rd participants (OPTIONAL!) */
  int num_ppl;                    /* int: 1 <= number_of_attendees <= 4 */
} Event;

/**
 * Functions used in the script.
 */

/**
 * Main functions.
 */
int add_ev(Event events[MAXEVENTS], int num_events);            /* op a*/
void list_all(Event events[MAXEVENTS], int num_events);         /* op l*/
void list_room(Event events[MAXEVENTS], int num_events);        /* op s*/
int del_ev(Event events[MAXEVENTS], int num_events);            /* op r*/
void change_init(Event events[MAXEVENTS], int num_events);      /* op i*/
void change_duration(Event events[MAXEVENTS], int num_events);  /* op t*/
void change_room(Event events[MAXEVENTS], int num_events);      /* op m*/
void add_part(Event events[MAXEVENTS], int num_events);         /* op A*/
void rmv_part(Event events[MAXEVENTS], int num_events);         /* op R*/

/**
 * Auxiliary functions.
 */
void str_clean(char in[MAXSTR]);
void str_cpy(char in[MAXSTR], char out[MAXSTR]);
int r_str(char in[MAXLINE], char out[MAXSTR], int index);
int r_num(char in[MAXLINE], int index, int len_num);
int len_num(char line[MAXLINE], int index);
Event parse_ev(char line[MAXLINE]);
int overlap_evs(Event ev1, Event ev2);
int match(char s1[MAXSTR], char s2[MAXSTR]);
int room_free(Event ev, Event events[MAXEVENTS], int num_events);
int part_in_ev(char part[MAXSTR], Event ev);
int person_free(char part[MAXSTR], Event ev, Event events[MAXEVENTS], int num_events, int code);
int people_free(Event temp, Event events[MAXEVENTS], int num_events, int code);
void print_ev(Event ev);
void pop_ev(int i_spot, Event events[MAXEVENTS], int num_events);
long date_stamp(Event ev);
int hhmm2min(Event ev);
int find_spot(Event ev, Event events[MAXEVENTS], int num_events);
void insert_ev(Event ev, Event events[MAXEVENTS], int num_events);
void del_part(char part[MAXSTR], int i_spot, Event events[MAXEVENTS]);

/**
 * main:
 *  Reads the operation char and performs the corresponding function.
 *  Returns 0 if program ran successfully.
 */
 int main() {
   char op;                                    /* operator: a, l, s, ... */
   Event events[MAXEVENTS]={0};                /* [0][0][0][...] */
   int num_events=0;

   while((op=getchar())!='x') {                /* op=='x' -> ends the script */
     switch(op) {
       case 'a':
         if(add_ev(events, num_events))        /* if event is successfully added */
           num_events++;                       /* increment number of events */
         break;
       case 'l':
         list_all(events, num_events);
         break;
       case 's':
         list_room(events, num_events);
         break;
       case 'r':
         if(del_ev(events, num_events))    /* if event is successfully removed */
           num_events--;                       /* decrement number of events */
         break;
       case 'i':
         change_init(events, num_events);
         break;
       case 't':
         change_duration(events, num_events);
         break;
       case 'm':
         change_room(events, num_events);
         break;
       case 'A':
         add_part(events, num_events);
         break;
       case 'R':
         rmv_part(events, num_events);
         break;
     }
   }
   return 0;
 }

/**
 * add_ev:
 *  Adds a new event.
 *  Returns TRUE if event was added.
 *  Returns FALSE otherwise.
 */
 int add_ev(Event events[MAXEVENTS], int num_events) {
   Event temp;
   char line[MAXLINE];

   getchar(); /* clear ' ' */
   fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */
   temp=parse_ev(line);

   /*if(room_free(temp, events)) {*/
   if(room_free(temp, events, num_events) && people_free(temp, events, num_events, 1)) {
     insert_ev(temp, events, num_events);
     return TRUE;
   }
   return FALSE;
 }

 /**
  * list_all:
  *  Lists all events ordered by their starting time.
  *  If multiple events start at the same time then they are sorted in ascending order by room number.
  */
 void list_all(Event events[MAXEVENTS], int num_events) {
   int i;
   for(i=0; i<num_events; i++)
     print_ev(events[i]);
 }

 /**
  * list_room:
  *  Lists all the events taking place in a certain room by chronological order.
  */
void list_room(Event events[MAXEVENTS], int num_events) {
  int i;
  int room=0;
  char line[MAXLINE];

  getchar(); /* clear ' ' */
  fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

  room=r_num(line, 0, 2);

  for(i=0; i<num_events; i++) {
    if(events[i].room==room)
      print_ev(events[i]);
  }
}

/**
 * del_ev:
 *  Deletes an event.
 */
int del_ev(Event events[MAXEVENTS], int num_events) {
  int i;
  char descrip[MAXLINE];
  char line[MAXLINE];

  getchar(); /* clear ' ' */
  fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

  r_str(line, descrip, 0);

  for(i=0; i<num_events; i++) {
    if(match(descrip, events[i].descrip)) {
      pop_ev(i, events, num_events);
      return TRUE;
    }
  }
  printf("Evento %s inexistente.\n", descrip);
  return FALSE;
}

/**
 * change_init:
 *  Changes an event's initial time (hh and mm).
 */
 void change_init(Event events[MAXEVENTS], int num_events) {
   char descrip[MAXSTR];
   Event ev;
   int i, hh=0, mm=0, index=0, done=0;
   char line[MAXLINE];

   getchar(); /* clear ' ' */
   fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

   index=r_str(line, descrip, 0);
   index++;
   hh=r_num(line, index, 2);
   index+=2;
   mm=r_num(line, index, 2);

   for(i=0; i<num_events; i++) {
     if(match(descrip, events[i].descrip)) {
       done++;
       ev=events[i];
       ev.hh=hh;
       ev.mm=mm;
       if(room_free(ev, events, num_events) && people_free(ev, events, num_events, 1)) {
         pop_ev(i, events, num_events);
         num_events--;
         insert_ev(ev, events, num_events);
       }
       break;
     }
   }
   if(!done)
     printf("Evento %s inexistente.\n", descrip);
 }

 /**
  * change_duration:
  *  Changes an event's duration.
  */
 void change_duration(Event events[MAXEVENTS], int num_events) {
   char descrip[MAXSTR];
   Event ev;
   int i, dur=0, index=0, done=0;
   char line[MAXLINE];

   getchar(); /* clear ' ' */
   fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

   index=r_str(line, descrip, 0); index++;
   dur=r_num(line, index, 4);

   for(i=0; i<num_events; i++) {
     if(match(descrip, events[i].descrip)) {
       done++;
       ev=events[i];
       ev.dur=dur;
       if(room_free(ev, events, num_events) && people_free(ev, events, num_events, 1)) {
         pop_ev(i, events, num_events);
         num_events--;
         insert_ev(ev, events, num_events);
       }
       break;
     }
   }
   if(!done)
     printf("Evento %s inexistente.\n", descrip);
 }

 /**
  * change_room:
  *  Changes an event's room.
  */
 void change_room(Event events[MAXEVENTS], int num_events) {
   char descrip[MAXSTR];
   Event ev;
   int i, room=0, index=0, done=0;
   char line[MAXLINE];

   getchar(); /* clear ' ' */
   fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

   index=r_str(line, descrip, 0);
   index++;
   room=r_num(line, index, 2);

   for(i=0; i<num_events; i++) {
     if(match(descrip, events[i].descrip)) {
       done++;
       ev=events[i];
       ev.room=room;
       if(room_free(ev, events, num_events) && people_free(ev, events, num_events, 1)) {
         pop_ev(i, events, num_events);
         num_events--;
         insert_ev(ev, events, num_events);
       }
       break;
     }
   }
   if(!done)
     printf("Evento %s inexistente.\n", descrip);
 }

 /**
  * add_part:
  *  Adds a certain participant to an existing event.
  *  If that participant is already part of the event then this function does nothing.
  */
 void add_part(Event events[MAXEVENTS], int num_events) {
   char descrip[MAXSTR];
   char part[MAXSTR];
   Event ev;
   int i, index=0, done=0;
   char line[MAXLINE];

   getchar(); /* clear ' ' */
   fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

   index=r_str(line, descrip, index);
   index++;

   for(i=0; i<num_events; i++) {
     if(match(descrip, events[i].descrip)) {
       done++;
       if(!part_in_ev(part,events[i])) {
         if(events[i].num_ppl==4)
           printf("Impossivel adicionar participante. Evento %s ja tem 3 participantes.\n", descrip);
         else {
           ev=events[i];
           r_str(line, ev.p[ev.num_ppl], index);
           ev.num_ppl++;
           if(room_free(ev, events, num_events) && people_free(ev, events, num_events, 0)) {
             pop_ev(i, events, num_events);
             num_events--;
             insert_ev(ev, events, num_events);
           }
         }
       }
       break;
     }
   }
   if(!done) {
     printf("Evento %s inexistente.\n", descrip);
   }
 }

 /**
  * rmv_part:
  *  Removes a certain participant from an existing event.
  *  If that participant isn't part of the event then this function does nothing.
  */
  void rmv_part(Event events[MAXEVENTS], int num_events) {
    char descrip[MAXSTR];
    char part[MAXSTR];
    int i, index=0, done=0;
    char line[MAXLINE];

    getchar(); /* clear ' ' */
    fgets(line, MAXLINE, stdin); /* line= [...]['\n']['\0'] */

    index=r_str(line, descrip, index);
    index++;
    r_str(line, part, index);

    for(i=0; i<num_events; i++) {
      if(match(descrip, events[i].descrip)) {
        done++;
        if(part_in_ev(part,events[i])) {
          if(events[i].num_ppl==2)
            printf("Impossivel remover participante. Participante %s e o unico participante no evento %s.\n", events[i].p[1], descrip);
          else {
            del_part(part, i, events);
            events[i].num_ppl--;
          }
        }
        break;
      }
    } if(!done)
        printf("Evento %s inexistente.\n", descrip);
    }



/* str_clean:
    Turns all chars in a str to '\0'. */
void str_clean(char in[MAXSTR]) {
  int i;
  for(i=0; i<MAXSTR; i++)
    in[i]='\0';
}

/* str_cpy:
    Copies str-in to str-out. */
void str_cpy(char in[MAXSTR], char out[MAXSTR]) {
  int i;
  str_clean(out);
  for(i=0; in[i]!='\0'; i++)
    out[i]=in[i];
  out[i]='\0';
}

/* r_str:
    Reads string (until it finds ':' or '\n').
    Returns next index (index to ':' or '\n', respectively). */
int r_str(char in[MAXLINE], char out[MAXSTR], int index) {
  int i;
  str_clean(out);
  for(i=index; in[i]!=DELIMITER && in[i]!='\n'; i++)
    out[i-index]=in[i];
  return i;
}

/* r_num:
    Reads number (until it finds ':' or '\n').
    Returns next index (index to ':' or '\n', respectively). */
int r_num(char in[MAXLINE], int index, int len_num) {
  int i, out=0;
  for(i=0; i<len_num && in[index+i]!='\n'; i++)
    out=out*10+in[index+i]-48;
  return out;
}

/* overlap_evs:
    Returns TRUE if 2 events overlap.
    Returns FALSE if otherwise. */
int overlap_evs(Event ev1, Event ev2) {
  return(ev1.year==ev2.year
         && ev1.month==ev2.month
         && ev1.day==ev2.day
         && ev1.hh*60+ev1.mm+ev1.dur>ev2.hh*60+ev2.mm
         && ev1.hh*60+ev1.mm<ev2.hh*60+ev2.mm+ev2.dur);
}

int match(char s1[MAXSTR], char s2[MAXSTR]) {
  return(!strcmp(s1,s2));
}

/* room_free:
    Returns TRUE if a room is free.
    Returns FALSE if otherwise. */
int room_free(Event ev, Event events[MAXEVENTS], int num_events) {
  int i;
  for(i=0; i<num_events; i++) {
    if(ev.room==events[i].room
       && !match(ev.descrip,events[i].descrip) /* if descriptions don't match! */
       && overlap_evs(ev, events[i])) {
         printf("Impossivel agendar evento %s. Sala%d ocupada.\n", ev.descrip, ev.room);
         return FALSE;
    }
  }
  return TRUE;
}

int part_in_ev(char part[MAXSTR], Event ev) {
  int i, res=0;
  for(i=0; i<ev.num_ppl; i++)
    if(match(part, ev.p[i]))
      res++;
  return res;
}

/* person_free:
    Returns TRUE if a person is free.
    Returns FALSE if otherwise. */
int person_free(char part[MAXSTR], Event ev, Event events[MAXEVENTS], int num_events, int code) {
  int i;
  for(i=0; i<num_events; i++) {
    if(!match(ev.descrip, events[i].descrip)
       && part_in_ev(part, events[i])
       && overlap_evs(ev, events[i])) {
          if(code)
              printf("Impossivel agendar evento %s. Participante %s tem um evento sobreposto.\n", ev.descrip, part);
          else
            printf("Impossivel adicionar participante. Participante %s tem um evento sobreposto.\n", part);
          return FALSE;
    }
  }
  return TRUE;
}

/* people_free:
    Returns TRUE if all people are free.
    Returns FALSE if otherwise. */
int people_free(Event temp, Event events[MAXEVENTS], int num_events, int code) {
  int i, res=1;
  for(i=0; i<temp.num_ppl; i++)
    res*=person_free(temp.p[i], temp, events, num_events, code);
  return res;
}

/* len_num:
    Returns how many chars away is the next delimiter, '\n' or '\0'. */
int len_num(char line[MAXLINE], int index) {
  int i=0;
  for(i=index; line[i]!=DELIMITER && line[i]!='\n' && line[i]!='\0'; i++)
    ;
  return i-index;
}

/* parse_ev:
    Converts line from input to an event. */
Event parse_ev(char line[MAXLINE]) {
  Event ev;
  int i, index=0;

  str_clean(ev.descrip);
  for(i=0; i<MAXPPL-1; i++)
    str_clean(ev.p[i]);

  /* a descrition:ddmmyyyy:hhmm:duration:room:leader:p0(:p1:p2:p3) */
  index=r_str(line, ev.descrip, 0);
  index++;
  ev.day=r_num(line, index, 2);
  index+=2;
  ev.month=r_num(line, index, 2);
  index+=2;
  ev.year=r_num(line, index, 4);
  index+=5;
  ev.hh=r_num(line, index, 2);
  index+=2;
  ev.mm=r_num(line, index, 2);
  index+=3;
  ev.dur=r_num(line, index, len_num(line, index));
  index+=(len_num(line, index)+1);
  ev.room=r_num(line, index, len_num(line, index));
  index+=(len_num(line, index)+1);
  for(i=0; line[index]!='\0'; i++) {
    index=r_str(line, ev.p[i], index);
    index++;
  }
  ev.num_ppl=i;
  return ev;
}

/* print_ev:
    Prints an event. */
void print_ev(Event ev) {
  int i;
  printf("%s %02d%02d%04d %02d%02d %d Sala%d %s\n*", ev.descrip, ev.day, ev.month, ev.year, ev.hh, ev.mm, ev.dur, ev.room, ev.p[0]);
  for(i=1; i<ev.num_ppl; i++)
    printf(" %s", ev.p[i]);
  printf("\n");
}

/* pop_ev:
    Erases an event from the event list by moving all the following events backwards one position. */
void pop_ev(int i_spot, Event events[MAXEVENTS], int num_events) {
  int i=0;
  for(i=i_spot; i<num_events-1; i++)
    events[i]=events[i+1];
}

/* date_stamp:
    Converts dd/mm/yyyy to yyyymmdd. */
long date_stamp(Event ev) {
  return(ev.year*10000+ev.month*100+ev.day);
}

/* hhmm2min:
    Converts hh:mm to hhmm. */
int hhmm2min(Event ev) {
  return(ev.hh*100+ev.mm);
}

/*find_spot:
    Returns the index an event should occupy for the events list to be ordered. */
int find_spot(Event ev, Event events[MAXEVENTS], int num_events) {
  int i;
  for(i=0; i<num_events; i++) {
    if((date_stamp(ev)<date_stamp(events[i]))
       || (date_stamp(ev)==date_stamp(events[i]) && hhmm2min(ev)<hhmm2min(events[i]))
       || (date_stamp(ev)==date_stamp(events[i]) && hhmm2min(ev)==hhmm2min(events[i]) && ev.room<events[i].room))
          return i;
  }
  return num_events;
}

/* insert_ev:
    Moves all events away from a spot and copies the new event in. */
void insert_ev(Event ev, Event events[MAXEVENTS], int num_events) {
  int i=0, i_spot;
  i_spot = find_spot(ev, events, num_events);
  for(i=num_events-1; i>=i_spot; i--)
    events[i+1]=events[i];
  events[i_spot]=ev;
}

void del_part(char part[MAXSTR], int i_spot, Event events[MAXEVENTS]) {
  int i;
  for(i=1; i<events[i_spot].num_ppl; i++) {
    if(match(part, events[i_spot].p[i])) {
      if(i==3)
        str_clean(events[i_spot].p[3]);
      else if(i==2) {
        str_cpy(events[i_spot].p[3], events[i_spot].p[2]);
        str_clean(events[i_spot].p[3]);
      } else if(i==1) {
        str_cpy(events[i_spot].p[2], events[i_spot].p[1]);
        str_cpy(events[i_spot].p[3], events[i_spot].p[2]);
        str_clean(events[i_spot].p[3]);
      }
    }
  }
}
