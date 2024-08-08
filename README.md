# GigHub - 점주와 알바생의 협업 플랫폼

![-1](https://github.com/user-attachments/assets/9ee68c9e-bc34-46f0-81e7-eaeace8d3cdd)

> **알바천국, 알바몬…** 모두 알바를 구하는 대학생들이라면 한 번쯤 들어봤을, 익숙한 이름들!
> 하지만 알바를 시작하고 나면, 어떤 플랫폼을 쓰나요?

가게마다 단체 카톡방에 의존하는 알바생 투두리스트, 인수인계, 사장님 공지사항 등등…

불편하고 놓치기도 쉬운 기존의 공지 시스템을 한 번에 바꿔줄, 

**알바계의 커뮤니티 플랫폼! 알바계의 Slack!** 

### **🫠GigHub**를 소개합니다!



# GigHub

![0](https://github.com/user-attachments/assets/c11cbe78-0d0f-417d-aa8e-04ad17a7dc1c)

일용직 노동자를 뜻하는 🧑‍🏭**Gig worker**, 이들이 모인 🌐**Hub** 

➡️ **GigHub** 입니다! (깃헙 아닙니다^.^)

# Team

| 이름     | 역할      | GitHub 링크                          |
|----------|-----------|--------------------------------------|
| 이은영   | Frontend  | [eunyoung-1118](https://github.com/eunyoung-1118) |
| 이재희   | Backend   | [jaehee831](https://github.com/jaehee831) |

# 기능

## 🫠 스플래시/로그인

<p align="center">
    <img src="https://github.com/user-attachments/assets/7dda5d43-6412-42f9-a8b1-e222f51ba720" alt="1,2" width="800"/>
</p>




- 카카오 로그인 api를 이용해 카카오계정 로그인을 구현했습니다.

- 유저는 **점주**와 **알바**로 포지션이 구분됩니다.

  - `user` 테이블의 `isadmin` 컬럼이 1이면 점주로 구분됩니다.

    

<img src="https://github.com/user-attachments/assets/acb26c15-8a14-4cb0-91fb-6fe5b0186bde" alt="3,5" width="400"/>



- 점주의 경우 가게를 등록할 수 있으며, 새 가게 채널이 형성되면 서버는 unique한 가게 암호를 반환합니다.

- 알바는 계좌번호를 입력하고, 사장님께 전달받은 가게 암호를 입력해 채널 멤버가 될 수 있습니다.

  

## 🫠 마이페이지

<img src="https://github.com/user-attachments/assets/c207eb05-51d6-48fa-9da7-fbcefc8f797f" alt="6,9" width="400"/>



- 점주는 마이페이지에서 가게 채널을 관리할 수 있습니다.

  - 일일 시간표를 수정하고 새로운 task 추가 가능

    <aside>
    💡 점주가 task를 등록하면 `add_task` api를 이용해서 task의 내용과  날짜, 배정된 직원 등의 정보를 DB에 저장합니다.


    </aside>

  - 매일 갱신되는 공지 보드 작성 가능

    <aside>
    💡 점주가 공지를 작성하면 `edit_notice`  api를 이용해서 해당 가게의 공지사항 정보를 업데이트합니다.


    </aside>

  - 알바생의 출퇴근 시간 및 급여 조회 가능

    <aside>
    💡 `get_store_members` api를 이용해서 DB에 저장되어 있는 해당 가게 직원들의 리스트를 불러옵니다.
    `get_member_work_time`, `get_user_wage` api를 이용해 각 직원들의 출퇴근 및 휴식시간, 시급을 가져와 월급을 계산해서 화면에 표시합니다.


    </aside>

  - 가게 채널 삭제 가능

    <aside>
    💡 점주는 자신의 채널을 선택해 삭제할 수 있습니다.


    </aside>

- 알바는 마이페이지에서 자신의 계정 정보를 조회할 수 있습니다.

  

## 🫠 홈화면 / 게시판

<img src="https://github.com/user-attachments/assets/58fbe0e8-7374-4503-8823-cb864c8e38b9" alt="10,13" width="400"/>



- GigHub의 꽃🌻이라 할 수 있는 게시판 기능!

- Slack, Discord 등의 커뮤니티 플랫폼처럼 각 목적에 따라 다양한 방을 만들고,

- 방에서 게시글을 추가해 멤버와 소통하고,

- 가게의 공지와 업무 시간표, 급여를 조회할 수 있습니다!

  <aside>
  💡 글을 작성하면 작성자, 작성시간, 제목, 내용 등의 게시글 정보가 DB에 저장됩니다.
  이후에 다른 직원이 게시판을 들어가면 DB에 있는 정보를 불러와 게시글을 보여줍니다.

  </aside>

  

## 🫠 하단 네비게이션 바

![14,15](https://github.com/user-attachments/assets/4be7fae8-1fe7-4af8-81a2-1ce4670b59fe)

### 멤버 탭

- 우리 가게에는 어떤 사람들이 있을까? 🫂**멤버 탭**에 들어가면 현재 채널의 다른 유저들을 볼 수 있습니다.

  <aside>
  💡 `get_store_members` api를 이용해서 가게에 가입한 알바생의 목록을 보여줍니다.


  </aside>

### 출첵봇 탭

- 알바생은 자신의 출/퇴근 시간, 휴식 시간을 **⏱️출첵봇 탭**에서 기록할 수 있습니다.

- 출퇴근 기록은 `attendance` 테이블에 저장되어, 유저는 출석 현황 로그를 조회할 수 있습니다.

  

# 기술 구현

- FE : Flutter

- BE : nodejs, MySQL

- Design : Figma

- IDE : VSCode

  

### ERD

<img src="https://github.com/user-attachments/assets/f9e136a3-3655-4eda-9bb3-b63585c5173b" alt="erd" width="400"/>



# 느낀 점

- 이재희

8일동안 한 번도 써보지 않은 툴(nodejs, mysql 등)을 사용해서 개발했는데 처음에는 막막했지만 열심히 한 보람이 있는 결과물이 나와서 좋았다. 아쉬운 점도 많지만, 다음에 기회가 된다면 db를 더욱 짜임새있게 구축해보고 싶다. 

- 이은영

프론트엔드를 배워보고 싶다는 마음에 flutter를 처음 배워봤고, 생각보다 굉장히 재미있었다. front와 back 사이에 소통하는 것이 중요하다는 것을 느낄 수 있었고, 새로운 것을 많이 배울 수 있었다. 중간에 컴퓨터가 고장나서 고통을 겪었지만 극복했다!
